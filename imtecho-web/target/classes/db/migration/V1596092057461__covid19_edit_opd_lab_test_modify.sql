DELETE FROM QUERY_MASTER WHERE CODE='covid_19_edit_opd_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'9308868a-bc1e-415c-b194-d15e7dc7f55f', 74840,  current_date , 74840,  current_date , 'covid_19_edit_opd_lab_test',
'is_hypertension,indications,occupation,refer_from_hospital,location_id,healthInfraId,abroad_contact_details,flight_no,contact_no,health_status,is_fever,pincode,case_no,pregnancy_status,current_bed_no,is_hiv,lastname,unit_no,is_abroad_in_contact,suggestedHealthInfra,opd_case_no,in_contact_with_covid19_paitent,is_copd,firstname,gender,date_of_onset_symptom,other_co_mobidity,is_breathlessness,emergency_contact_name,labHealthInfraId,emergency_contact_no,travel_history,is_diabetes,is_malignancy,is_cough,address,is_sari,is_other_co_mobidity,middlename,is_immunocompromized,collectionDate,is_renal_condition,isMigrant,travelled_place,is_heart_patient,otherIndications,admissionId,age,current_ward_id,ageMonth',
'begin;
update covid19_admission_detail
set
first_name = case when #firstname# != null then #firstname# else null end,
middle_name = case when #middlename# != null then #middlename# else null end,
last_name = case when #lastname# != null then #lastname# else null end,
address = case when #address# != null then #address# else null end,
pincode = #pincode#,
occupation = case when #occupation# != null then #occupation# else null end,
travel_history = case when #travel_history# != null then #travel_history# else null end,
travelled_place = case when #travelled_place# != null then #travelled_place# else null end,
flight_no = case when #flight_no# != null then #flight_no# else null end,
is_abroad_in_contact = case when #is_abroad_in_contact# != null then #is_abroad_in_contact# else null end,
in_contact_with_covid19_paitent = case when #in_contact_with_covid19_paitent# != null then #in_contact_with_covid19_paitent# else null end,
abroad_contact_details = case when #abroad_contact_details# != null then #abroad_contact_details# else null end,
case_no = case when #case_no# != null then #case_no# else null end ,
opd_case_no = case when #opd_case_no# != null then #opd_case_no# else null end,
contact_number = case when #contact_no# != null then #contact_no# else null end,
gender = case when #gender# != null then #gender# else null end,
pregnancy_status = case when #pregnancy_status# != null then #pregnancy_status# else null end,
age = #age#,
is_fever = #is_fever#,
is_cough = #is_cough#,
is_breathlessness = #is_breathlessness#,
is_sari = #is_sari#,
is_hiv = #is_hiv#,
is_heart_patient = #is_heart_patient#,
is_diabetes = #is_diabetes#,
is_copd = #is_copd#,
is_hypertension = #is_hypertension#,
is_renal_condition = #is_renal_condition#,
is_immunocompromized = #is_immunocompromized#,
is_malignancy = #is_malignancy#,
is_other_co_mobidity = #is_other_co_mobidity#,
other_co_mobidity = case when #other_co_mobidity# != null then #other_co_mobidity# else null end,
indications = case when #indications# != null then #indications# else null end,
date_of_onset_symptom = (case when #date_of_onset_symptom# = null then null else to_date(#date_of_onset_symptom#,''MM-DD-YYYY'') end),
refer_from_hospital = case when #refer_from_hospital# != null then #refer_from_hospital# else null end,
current_bed_no = case when #current_bed_no# != null then #current_bed_no# else null end,
unit_no = case when #unit_no# != null then #unit_no# else null end,
emergency_contact_name = case when #emergency_contact_name# != null then #emergency_contact_name# else null end,
emergency_contact_no = case when #emergency_contact_no# != null then #emergency_contact_no# else null end,
current_ward_id = #current_ward_id#,
is_migrant=#isMigrant#,
age_month=case when #ageMonth# = null then age_month else #ageMonth#  end,
indication_other=case when #otherIndications# != null then #otherIndications# else null end,
location_id = #location_id#,
suggested_health_infra = #suggestedHealthInfra#
where id = #admissionId#;

update covid19_admitted_case_daily_status
set
location_id = #location_id#,
health_status = case when #health_status# != null then #health_status# else null end
where admission_id = #admissionId#;

update covid19_lab_test_detail
set
sample_health_infra = #healthInfraId# ,
sample_health_infra_send_to = #labHealthInfraId# ,
lab_collection_on =to_timestamp(#collectionDate#,''DD/MM/YYYY HH24:MI:SS'')
where covid_admission_detail_id = #admissionId#;

commit;',
null,
false, 'ACTIVE');