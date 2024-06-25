delete from QUERY_MASTER where CODE='covid19_retrieve_admission_details';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_retrieve_admission_details',
'admissionId',
'select get_location_hierarchy(location_id) as "location",
address as "address",
pincode as "pincode",
occupation as "occupation",
travel_history as "travelHistory",
is_abroad_in_contact as "abroadContact",
in_contact_with_covid19_paitent as "covidPositiveContact",
case_no as "caseNumber",
opd_case_no as "opdCaseNumber",
contact_number as "contactNumber",
gender as "gender",
is_fever as "fever",
is_cough as "cough",
is_breathlessness as "breathlessness",
is_sari as "sari",
is_hiv as "hiv",
is_heart_patient as "heartPatient",
is_diabetes as "diabetes",
is_copd as "copd",
is_hypertension as "hypertension",
is_renal_condition as "renalCondition",
is_immunocompromized as "immunocompromized",
is_malignancy as "maligancy",
date_of_onset_symptom as "onsetDate",
unit_no as "unitNumber",
concat(emergency_contact_name,'' ('',emergency_contact_no,'')'') as "emergencyDetails"
from covid19_admission_detail
where id = #admissionId#',
null,
true, 'ACTIVE');