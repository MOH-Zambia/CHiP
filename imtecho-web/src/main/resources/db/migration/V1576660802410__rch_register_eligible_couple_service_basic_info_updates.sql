
--get_rch_register_eligible_couple_service_basic_info

update query_master
set query = '
with dates as (
select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
),lmp_followup_det as (
select lfu.member_id
,cast(json_agg(json_build_object(''date'',cast(lfu.service_date as date),''contraception_method'',lfu.family_planning_method)) as text) as lmp_visit_info
from rch_lmp_follow_up lfu
inner join dates on lfu.created_on between dates.from_date and dates.to_date
inner join location_hierchy_closer_det lh on lfu.location_id = lh.child_id and lh.parent_id = #location_id#
where
lfu.member_status = ''AVAILABLE''
group by lfu.member_id
),eligible_couple_det as (
select
m.id as member_id
,sum(case when fam_mem.mother_id = m.id then 1 else 0 end) as total_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''M''  then 1 else 0 end) as total_male_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''F''  then 1 else 0 end) as total_female_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''M''
 and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then 1 else 0 end) as total_live_male_child
,sum(case when fam_mem.mother_id = m.id and fam_mem.gender = ''F''
and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then 1 else 0 end) as total_live_female_child
,max(case when similarity(fam_mem.first_name,m.middle_name) > 0.8 then fam_mem.id else null end) as husband_id
,min(case when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'',''NEW'',''REVERIFICATION'')  then m.dob else null end) as last_child_dob
from lmp_followup_det as eligible_couple
inner join imt_member m on m.id = eligible_couple.member_id
left join imt_member fam_mem on fam_mem.family_id = m.family_id
group by m.id
)
select
m.id as member_id,
m.unique_health_id as unique_health_id,
cast (m.created_on as date)  as registration_date,
concat(m.first_name,'' '',m.middle_name,'' '',m.last_name,'' ('',m.unique_health_id,'')'') as  member_name,
EXTRACT(YEAR FROM age(cast(m.dob as date))) as member_current_age,
case when m.year_of_wedding is null then null else m.year_of_wedding - date_part(''year'', m.dob)  end as  member_marriage_age,
m.middle_name as husband_name,
EXTRACT(YEAR FROM age(cast(husband.dob as date))) as husband_current_age,
case when m.year_of_wedding is null then null else m.year_of_wedding - date_part(''year'', husband.dob)  end as  husband_marriage_age,
concat_ws('','',f.address1,f.address2) as address,
religion.value as religion,
caste.value as cast,
case when f.bpl_flag then ''BPL'' end as bpl_apl,
ec.total_male_child as total_given_male_birth,
ec.total_female_child as total_given_female_birth,
ec.total_live_male_child as live_male_birth,
ec.total_live_female_child as live_female_birth,
EXTRACT(YEAR FROM age(cast(ec.last_child_dob as date))) as smallest_child_age,
cast(''Male'' as text) as smallest_child_gender,
lmp_followup_det.lmp_visit_info as lmp_visit_info,
m.date_of_wedding as date_of_wedding
from lmp_followup_det
inner join imt_member m on m.id = lmp_followup_det.member_id
inner join eligible_couple_det ec on lmp_followup_det.member_id = ec.member_id
inner join imt_family f on f.family_id=m.family_id
left join imt_member husband on husband.id =ec.husband_id
left join listvalue_field_value_detail religion on religion.id = cast(f.religion as int)
left join listvalue_field_value_detail caste on caste.id = cast(f.caste as int)
order by m.date_of_wedding
limit #limit# offset #offset#;
' where code = 'get_rch_register_eligible_couple_service_basic_info';
