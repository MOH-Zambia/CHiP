DELETE FROM QUERY_MASTER WHERE CODE='covid19_fetch_patients_admitted_more_than_15_days';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'covid19_fetch_patients_admitted_more_than_15_days',
 null,
'select
member_det as "name",
age as "age",
case when gender = ''F'' then ''Female'' else ''Male'' end as "gender",
case when hid.name_in_english is null then hid.name else hid.name_in_english end as "facility",
im.english_name as "area",
case when dob is null then ''-'' else to_char(dob,''DD-MM-YYYY'') end as "dob",
case when admission_date is null then ''-'' else to_char(admission_date,''DD-MM-YYYY'') end as "admission_date",
caad.address as address ,
caad.mobidity as "morbidities"
from covid19_admission_analytics_details caad
left join location_master im on im.id = caad.location_id
left join health_infrastructure_details hid on hid.id = caad.health_infra_id
where positive_member = 1
and admission_date <=  now() - interval ''15 days'' and discharge_date is null',
null,
true, 'ACTIVE');