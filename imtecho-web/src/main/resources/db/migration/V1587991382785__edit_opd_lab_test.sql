DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_lab_test_for_edit';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid_19_get_opd_lab_test_for_edit', 
'admissionId', 
'select
admission.member_id,
admission.id,
first_name as "firstname",
middle_name as "middlename",
last_name as "lastname",
admission.address as "address",
loc.english_name as "loc_name", 
loc.id as "districtLocationId",
case when pincode is null or pincode = ''null'' or pincode = ''\"null\"'' then null else cast(pincode as integer) end as "pinCode",
occupation as "occupation",
travel_history as "travelHistory",
travelled_place as "travelledPlace",
flight_no as "flightno",
is_abroad_in_contact as "is_abroad_in_contact",
in_contact_with_covid19_paitent as "inContactWithCovid19Paitent",
abroad_contact_details as "abroad_contact_details",
case_no as "case_number",
opd_case_no as "opdCaseNo",
cast(contact_number as numeric) as "contact_no",
admission.gender as "gender",
pregnancy_status as "pregnancy_status",
age as "age",
age_month as "ageMonth",
is_fever as "hasFever",
is_cough as "hasCough",
is_breathlessness as "hasShortnessBreath",
is_sari as "isSari",
is_hiv as "isHIV",
is_heart_patient as "isHeartPatient",
is_diabetes as "isDiabetes",
is_copd as "isCOPD",
is_hypertension as "isHypertension",
is_renal_condition as "isRenalCondition",
is_immunocompromized as "isImmunocompromized",
is_malignancy as "isMalignancy",
is_other_co_mobidity as "isOtherCoMobidity",
other_co_mobidity as "otherCoMobidity",
indications as "indications",
date_of_onset_symptom as "date_of_onset_symptom",
refer_from_hospital as "referFromHosital",
ward.id as "ward_id",
ward.ward_name as "ward_name",
current_bed_no as "bedno",
unit_no as "unitno",
health_status as "healthstatus",
emergency_contact_name as "emergencyContactName",
case when emergency_contact_no is null or emergency_contact_no = ''null'' or emergency_contact_no = ''\"null\"'' then null else cast(emergency_contact_no as bigint) end as "emergencyContactNo",
is_migrant as "isMigrant",
indication_other as "otherIndications",
cltd.sample_health_infra as "health_infra_id",
cltd.sample_health_infra_send_to as "labHealthInfraId",
cltd.lab_collection_on as "collectionDate",
suggested_health_infra as "suggestedHealthInfra"
from covid19_admission_detail admission left join covid19_admitted_case_daily_status daily on admission.id  = daily.admission_id
inner join covid19_lab_test_detail cltd on cltd.id = admission.last_lab_test_id
left join location_master loc on loc.id = daily.location_id and type in (''D'',''C'')
left join health_infrastructure_ward_details ward on ward.id  = admission.current_ward_id
where
admission.id = #admissionId#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid_19_edit_opd_lab_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid_19_edit_opd_lab_test', 
'is_hypertension,indications,occupation,refer_from_hospital,location_id,health_infra_id,abroad_contact_details,flight_no,contact_no,health_status,is_fever,pincode,case_no,pregnancy_status,current_bed_no,is_hiv,lastname,unit_no,is_abroad_in_contact,suggestedHealthInfra,opd_case_no,in_contact_with_covid19_paitent,is_copd,firstname,gender,date_of_onset_symptom,other_co_mobidity,is_breathlessness,emergency_contact_name,labHealthInfraId,emergency_contact_no,travel_history,is_diabetes,is_malignancy,is_cough,address,is_sari,is_other_co_mobidity,middlename,is_immunocompromized,collectionDate,is_renal_condition,isMigrant,travelled_place,is_heart_patient,otherIndications,admissionId,age,current_ward_id,ageMonth', 
'begin;
update covid19_admission_detail
set
first_name = case when ''#firstname#'' != ''null'' then ''#firstname#'' else null end,
middle_name = case when ''#middlename#'' != ''null'' then ''#middlename#'' else null end,
last_name = case when ''#lastname#'' != ''null'' then ''#lastname#'' else null end,
address = case when ''#address#'' != ''null'' then ''#address#'' else null end,
pincode = #pincode#,
occupation = case when ''#occupation#'' != ''null'' then ''#occupation#'' else null end,
travel_history = case when ''#travel_history#'' != ''null'' then ''#travel_history#'' else null end,
travelled_place = case when ''#travelled_place#'' != ''null'' then ''#travelled_place#'' else null end,
flight_no = case when ''#flight_no#'' != ''null'' then ''#flight_no#'' else null end,
is_abroad_in_contact = case when ''#is_abroad_in_contact#'' != ''null'' then ''#is_abroad_in_contact#'' else null end,
in_contact_with_covid19_paitent = case when ''#in_contact_with_covid19_paitent#'' != ''null'' then ''#in_contact_with_covid19_paitent#'' else null end,
abroad_contact_details = case when ''#abroad_contact_details#'' != ''null'' then ''#abroad_contact_details#'' else null end,
case_no = case when ''#case_no#'' != ''null'' then ''#case_no#'' else null end ,
opd_case_no = case when ''#opd_case_no#'' != ''null'' then ''#opd_case_no#'' else null end,
contact_number = case when ''#contact_no#'' != ''null'' then ''#contact_no#'' else null end,
gender = case when ''#gender#'' != ''null'' then ''#gender#'' else null end,
pregnancy_status = case when ''#pregnancy_status#'' != ''null'' then ''#pregnancy_status#'' else null end,
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
other_co_mobidity = case when ''#other_co_mobidity#'' != ''null'' then ''#other_co_mobidity#'' else null end,
indications = case when ''#indications#'' != ''null'' then ''#indications#'' else null end,
date_of_onset_symptom = (case when ''#date_of_onset_symptom#'' = ''null'' then null else to_date(''#date_of_onset_symptom#'',''MM-DD-YYYY'') end),
refer_from_hospital = case when ''#refer_from_hospital#'' != ''null'' then ''#refer_from_hospital#'' else null end,
current_bed_no = case when ''#current_bed_no#'' != ''null'' then ''#current_bed_no#'' else null end,
unit_no = case when ''#unit_no#'' != ''null'' then ''#unit_no#'' else null end,
emergency_contact_name = case when ''#emergency_contact_name#'' != ''null'' then ''#emergency_contact_name#'' else null end,
emergency_contact_no = case when ''#emergency_contact_no#'' != ''null'' then ''#emergency_contact_no#'' else null end,
current_ward_id = #current_ward_id#,
is_migrant=#isMigrant#,
age_month=case when ''#ageMonth#'' = ''null'' then age_month else #ageMonth#  end,
indication_other=case when ''#otherIndications#'' != ''null'' then ''#otherIndications#'' else null end,
location_id = #location_id#,
suggested_health_infra = #suggestedHealthInfra#
where id = #admissionId#;

update covid19_admitted_case_daily_status
set 
location_id = #location_id#,
health_status = case when ''#health_status#'' != ''null'' then ''#health_status#'' else null end 
where admission_id = #admissionId#;

update covid19_lab_test_detail
set 
sample_health_infra = #health_infra_id#,
sample_health_infra_send_to = #labHealthInfraId# ,
lab_collection_on =to_timestamp(''#collectionDate#'',''DD/MM/YYYY HH24:MI:SS'')
where covid_admission_detail_id = #admissionId#;

commit;', 
null, 
false, 'ACTIVE');