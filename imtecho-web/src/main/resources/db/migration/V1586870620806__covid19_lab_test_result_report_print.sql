DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_result_report_print';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_lab_test_result_report_print', 
'labTestIds', 
'select admission.name_in_english as hospital_name,
admission.address as hospital_address,
to_char(now(),''DD/MM/YYYY HH24:MM'') as reporting_date,
referring.name_in_english as referring_hospital,
to_char(covid19_admission_detail.date_of_onset_symptom,''DD/MM/YYYY'') as onset_illness_date,
to_char(covid19_lab_test_detail.lab_collection_on,''DD/MM/YYYY HH24:MM'') as sample_collection_date,
to_char(covid19_lab_test_detail.lab_sample_received_on,''DD/MM/YYYY HH24:MM'') as receipt_date,
cast(''N.A'' as text) as quality_on_arrival,
covid19_lab_test_detail.lab_test_id as report_id,
covid19_lab_test_detail.lab_test_id as sample_id,
concat(covid19_admission_detail.first_name,'' '',covid19_admission_detail.middle_name,'' '',covid19_admission_detail.last_name) as patient_name,
cast(covid19_admission_detail.age as text) as age,
covid19_admission_detail.gender as sex,
cast(''N.A'' as text) as specimen_type,
to_char(covid19_lab_test_detail.lab_result_entry_on,''DD/MM/YYYY HH24:MM'') as date_of_sample_testing,
covid19_lab_test_detail.lab_result as SARS_CoV_2_result,
cast(''N.A'' as text) as other_respiratory_virus,
covid19_admission_detail.address as patient_address,
cacd.remarks as remarks,
cast(''N.A'' as text) as electronically_signed_by
from covid19_lab_test_detail
inner join covid19_admission_detail on covid19_lab_test_detail.covid_admission_detail_id = covid19_admission_detail.id
inner join covid19_admitted_case_daily_status cacd on cacd.id = covid19_admission_detail.last_check_up_detail_id
left join health_infrastructure_details admission on covid19_admission_detail.health_infra_id = admission.id
left join health_infrastructure_details referring on covid19_lab_test_detail.sample_health_infra = referring.id
where covid19_lab_test_detail.id in (#labTestIds#)', 
null, 
true, 'ACTIVE');