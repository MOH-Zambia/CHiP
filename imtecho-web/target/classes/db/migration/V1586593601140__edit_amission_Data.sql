--covid19_update_admitted_patients_det_for_editing
DELETE FROM QUERY_MASTER WHERE CODE='covid19_update_admitted_patients_det_for_editing';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'covid19_update_admitted_patients_det_for_editing', 
'is_copd,is_hypertension,firstname,indications,occupation,gender,refer_from_hospital,date_of_onset_symptom,other_co_mobidity,is_breathlessness,emergency_contact_name,location_id,abroad_contact_details,emergency_contact_no,flight_no,travel_history,admission_date,is_diabetes,is_malignancy,health_status,is_fever,is_cough,pincode,case_no,address,is_sari,pregnancy_status,is_other_co_mobidity,middlename,current_bed_no,is_immunocompromized,contact_number,is_hiv,lastname,is_renal_condition,isMigrant,travelled_place,is_heart_patient,otherIndications,unit_no,is_abroad_in_contact,admissionId,opd_case_no,in_contact_with_covid19_paitent,age,current_ward_id,ageMonth', 
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
admission_date = ''#admission_date#'',
case_no = case when ''#case_no#'' != ''null'' then ''#case_no#'' else null end ,
opd_case_no = case when ''#opd_case_no#'' != ''null'' then ''#opd_case_no#'' else null end,
contact_number = case when ''#contact_number#'' != ''null'' then ''#contact_number#'' else null end,
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
date_of_onset_symptom = ''#date_of_onset_symptom#'',
refer_from_hospital = case when ''#refer_from_hospital#'' != ''null'' then ''#refer_from_hospital#'' else null end,
current_bed_no = case when ''#current_bed_no#'' != ''null'' then ''#current_bed_no#'' else null end,
unit_no = case when ''#unit_no#'' != ''null'' then ''#unit_no#'' else null end,
emergency_contact_name = case when ''#emergency_contact_name#'' != ''null'' then ''#emergency_contact_name#'' else null end,
emergency_contact_no = case when ''#emergency_contact_no#'' != ''null'' then ''#emergency_contact_no#'' else null end,
current_ward_id = #current_ward_id#,
is_migrant=#isMigrant#,
age_month=case when ''#ageMonth#'' = ''null'' then age_month else #ageMonth#  end,
indication_other=case when ''#otherIndications#'' != ''null'' then ''#otherIndications#'' else null end
where id = #admissionId#;

update covid19_admitted_case_daily_status
set 
location_id = #location_id#,
health_status = case when ''#health_status#'' != ''null'' then ''#health_status#'' else null end 
where id = #admissionId#;

commit;', 
null, 
false, 'ACTIVE');

--covid19_get_admitted_patients_det_for_editing
DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_admitted_patients_det_for_editing';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74841,  current_date , 74841,  current_date , 'covid19_get_admitted_patients_det_for_editing', 
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
to_char(admission_date,''DD/MM/YYYY'') as "admissionDate",
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
indication_other as "otherIndications"

from covid19_admission_detail admission left join covid19_admitted_case_daily_status daily on admission.id  = daily.id
left join location_master loc on loc.id = daily.location_id and type in (''D'',''C'')
left join health_infrastructure_ward_details ward on ward.id  = admission.current_ward_id
where
admission.id = #admissionId#', 
null, 
true, 'ACTIVE');