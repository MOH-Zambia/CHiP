
---- get_rch_register_eligible_couple_service_detailed_info

update query_master
set query = '
with dates as (
	select
	to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+ interval ''1 day'' - interval ''1 millisecond'' as to_date
),
lmp_followup_det as (
	select
	lfu.member_id,
	cast(
	    json_agg(
	        json_build_object(
	            ''date'',
	            cast(lfu.service_date as date),
	            ''contraception_method'',
	            case
	                when lfu.family_planning_method = ''NONE'' then ''None''
	                when lfu.family_planning_method = ''ANTARA'' then ''Antara''
	                when lfu.family_planning_method = ''IUCD5'' then ''IUCD 5 Years''
	                when lfu.family_planning_method = ''IUCD10'' then ''IUCD 10 Years''
	                when lfu.family_planning_method = ''CONDOM'' then ''Condom''
	                when lfu.family_planning_method = ''ORALPILLS'' then ''Oral Pills''
	                when lfu.family_planning_method = ''CHHAYA'' then ''Chhaya''
	                when lfu.family_planning_method = ''ANTARA'' then ''Antara''
	                when lfu.family_planning_method = ''CONTRA'' then ''Emergency Contraceptive Pills''
	                when lfu.family_planning_method = ''FMLSTR'' then ''Female Sterilization''
	                when lfu.family_planning_method = ''MLSTR'' then ''Male Sterilization''
			        when lfu.family_planning_method = ''OTHER'' then ''Other''
			        when lfu.family_planning_method = ''CHHANT'' then ''Chhant''
	                else lfu.family_planning_method
                end
            )
        ) as text) as lmp_visit_info
	from rch_lmp_follow_up lfu
	inner join dates on lfu.created_on
		between dates.from_date and dates.to_date
	where lfu.member_status = ''AVAILABLE''
		and lfu.member_id = #member_id#
	group by lfu.member_id
),
last_child_dob as (
    select
    m.id as member_id,
    min(
        case
			when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then fam_mem.dob
			else null
		end) as last_child_dob
	from lmp_followup_det as eligible_couple
	inner join imt_member m on m.id = eligible_couple.member_id
	left join imt_member fam_mem on fam_mem.family_id = m.family_id
	group by m.id
),
eligible_couple_det as (
	select
	m.id as member_id,
	sum(case
			when fam_mem.mother_id = m.id then 1
			else 0
		end) as total_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''M'' then 1
			else 0
		end) as total_male_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''F'' then 1
			else 0
		end) as total_female_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''M'' and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then 1
			else 0
		end) as total_live_male_child,
	sum(case
			when fam_mem.mother_id = m.id and fam_mem.gender = ''F'' and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then 1
			else 0
		end) as total_live_female_child,
	max(case
			when similarity(fam_mem.first_name,m.middle_name) > 0.8 then fam_mem.id
			else null
		end) as husband_id,
	min(
        case
			when fam_mem.mother_id = m.id and fam_mem.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'') then fam_mem.dob
			else null
		end) as last_child_dob,
	max(
	    case
	        when last_child.gender is null then null
	        when last_child.gender = ''F'' then ''Female''
	        else ''Male''
	     end) as last_child_gender
	from lmp_followup_det as eligible_couple
	inner join imt_member m on m.id = eligible_couple.member_id
	left join imt_member fam_mem on fam_mem.family_id = m.family_id
	left join last_child_dob lcd on lcd.member_id = eligible_couple.member_id
	left join imt_member last_child on last_child.mother_id = m.id
	    and last_child.basic_state in (''VERIFIED'', ''NEW'', ''REVERIFICATION'')
	    and last_child.dob in (select last_child_dob from last_child_dob)
	group by m.id
)
select
m.id as member_id,
m.unique_health_id as unique_health_id,
to_char(m.created_on, ''dd-MM-yyyy'') as registration_date,
concat_ws('' '', m.first_name, m.middle_name, m.last_name) as member_name,
case
    when m.aadhar_number_available is true then ''Yes''
    else ''No''
end as member_aadhar_number_available,
case
	when m.account_number is null then ''No''
	else ''Yes''
end as member_bank_account_number_available,
EXTRACT(YEAR FROM age(cast(m.dob as date))) as member_current_age,
case
	when m.year_of_wedding is null then null
	else m.year_of_wedding - date_part(''year'', m.dob)
end as member_marriage_age,
case
    when m.husband_name is null then concat_ws('' '', m.middle_name, m.last_name)
    else m.husband_name
end as husband_name,
EXTRACT(YEAR FROM age(cast(husband.dob as date))) as husband_current_age,
case
	when m.year_of_wedding is null then null
	else m.year_of_wedding - date_part(''year'', husband.dob)
end as husband_marriage_age,
case
	when (f.address1 is null and f.address2 is null) then ''N/A''
	else
		case
			when f.address1 is null then f.address2
			when f.address2 is null then f.address1
			else concat(f.address1, '','', f.address2)
		end
end as address,
case
	when religion.value = ''HINDU'' then ''Hindu''
	when religion.value = ''CHRISTIAN'' then ''Christian''
	when religion.value = ''MUSLIM'' then ''Muslim''
	when religion.value = ''OTHERS'' then ''Others''
	else religion.value
end as religion,
case
	when caste.value = ''GENERAL'' then ''General''
	else caste.value
end as cast,
case
	when f.bpl_flag then ''BPL''
end as bpl_apl,
m.eligible_couple_date,
ec.total_male_child as total_given_male_birth,
ec.total_female_child as total_given_female_birth,
ec.total_live_male_child as live_male_birth,
ec.total_live_female_child as live_female_birth,
EXTRACT(YEAR FROM age(cast(ec.last_child_dob as date))) as smallest_child_age,
ec.last_child_gender as smallest_child_gender,
lmp_followup_det.lmp_visit_info as lmp_visit_info
from lmp_followup_det
inner join imt_member m on m.id = lmp_followup_det.member_id
inner join eligible_couple_det ec on lmp_followup_det.member_id = ec.member_id
inner join imt_family f on f.family_id=m.family_id
left join imt_member husband on husband.id =ec.husband_id
left join listvalue_field_value_detail religion on religion.id = cast(f.religion as int)
left join listvalue_field_value_detail caste on caste.id = cast(f.caste as int);
' where code = 'get_rch_register_eligible_couple_service_detailed_info';
