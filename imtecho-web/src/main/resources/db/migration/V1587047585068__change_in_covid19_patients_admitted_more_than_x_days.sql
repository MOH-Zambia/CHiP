delete from query_master qm where qm.code = 'covid19_fetch_patients_admitted_more_than_15_days';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(74909,'2020-04-13 00:00:00.000',80208,'2020-04-16 19:43:20.882','covid19_fetch_patients_admitted_more_than_15_days','days','select
member_det as "name",
caad.health_state as "healthState",
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
and admission_date <=  now() - interval ''#days# days'' and discharge_date is null',true,'ACTIVE',NULL,true)
;