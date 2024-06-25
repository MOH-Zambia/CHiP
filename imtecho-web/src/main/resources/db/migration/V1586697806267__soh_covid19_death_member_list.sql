DELETE FROM QUERY_MASTER WHERE CODE='soh_covid19_positive_member_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'soh_covid19_positive_member_list', 
 null, 
'with marker_date as (
	select TO_TIMESTAMP(sc.key_value, ''YYYY-MM-DD HH24:MI:SS'') as last_marker_date from system_configuration sc where sc.system_key = ''COVID19_LAST_MARKET_DATE''
)
select 
member_det as "name",
age as "age",
case when gender = ''F'' then ''Female'' else ''Male'' end as "gender",	
hid.name_in_english as "facility",
im.english_name as "area",
im.id,
case when dob is null then ''-'' else to_char(dob,''DD-MM-YYYY'') end as "dob",
caad.address as address ,
case when caad.death_date is not null then to_char(caad.death_date,''DD/MM/YYYY'') else ''-'' end as "dod",
caad.mobidity as "morbidities"
from covid19_admission_analytics_details caad
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
left join location_master im on im.id = caad.location_id
where  positive_member = 1
and system_postive_date > (select last_marker_date from marker_date)', 
null, 
true, 'ACTIVE');