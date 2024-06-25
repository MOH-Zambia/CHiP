
---- get_rch_register_mother_service_basic_info

update query_master
set query = '
with location_det as(
	select child_id as loc_id from location_hierchy_closer_det where parent_id = #location_id#
),dates as(
	select to_date(case when ''#from_date#'' = ''null'' then null else ''#from_date#'' end,''MM/DD/YYYY'') as from_date,
	to_date(case when ''#to_date#'' = ''null'' then null else ''#to_date#'' end,''MM/DD/YYYY'')+interval ''1 day'' - interval ''1 millisecond'' as to_date
)
,member_det as (
	(select pregnancy_reg_id as ref_id, member_id, reg_service_date
	from rch_pregnancy_analytics_details,dates,location_det
	where ''#serviceType#'' in (''rch_mother_service'')
	and reg_service_date between dates.from_date and dates.to_date
	and member_current_location_id = location_det.loc_id
	order by reg_service_date)
)
select member_det.ref_id,mem.id as member_id, concat(mem.first_name,'' '',mem.last_name,'' ('',mem.unique_health_id,'')'') as member_name,
mem.middle_name as husband_name, concat(fam.address1, '','', fam.address2) as address, date_part(''years'',age(localtimestamp, dob)) as age,
rel.value as religion, cas.value as cast,
member_det.reg_service_date
from imt_member mem
inner join member_det on mem.id = member_det.member_id
inner join imt_family fam on mem.family_id = fam.family_id
left join listvalue_field_value_detail cas on fam.caste = (cast(cas.id as varchar))
left join listvalue_field_value_detail rel on fam.religion = (cast(rel.id as varchar))
order by member_det.reg_service_date
limit #limit# offset #offset#
' where code = 'get_rch_register_mother_service_basic_info';
