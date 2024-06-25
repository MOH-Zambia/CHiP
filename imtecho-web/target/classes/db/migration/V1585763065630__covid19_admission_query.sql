alter table covid19_admission_detail
drop column if exists  unit_no,
drop column if exists  flight_no,
drop column if exists  refer_from_hospital,
add column unit_no text,
add column flight_no text,
add column refer_from_hospital text;



delete from query_master where code = 'insert_covid19_new_admission_detail';

INSERT INTO query_master
( created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES( 80248, '2020-03-30 23:52:21.584', 409, '2020-04-02 01:27:24.562', 'insert_covid19_new_admission_detail', 'firstname,occupation,gender,bed_no,date_of_onset_symptom,isHypertension,isRenalCondition,emergencyContactNo,isHeartPatient,abroad_contact_details,flightno,referFromHosital,admission_date,locationId,contact_no,case_number,health_status,memberId,isImmunocompromized,member_id,address,unitno,loggedIn_user,ward_no,emergencyContactName,hasCough,pregnancy_status,middlename,travelHistory,loggedInUserId,isCOPD,travelledPlace,lastname,isMalignancy,hasShortnessBreath,covid19_lab_test_recommendation_id,hasFever,isHIV,districtLocationId,pinCode,is_abroad_in_contact,isDiabetes,age', 'with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id 
),health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#districtLocationId#,(select id from generated_id),''#admission_date#'',#ward_no#,''#bed_no#'',''#health_status#'',''#loggedInUserId#'',now())
returning id
),insert_lab_test as (
INSERT INTO public.covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, (select id from generated_id),''COLLECTION_PENDING'',''#loggedInUserId#'',now(), (select id from health_infra_det))
returning id
),update_lab_test_recommdation as (
update covid19_lab_test_recommendation set admission_id = (select id from generated_id)
where id = #covid19_lab_test_recommendation_id#
)
insert into covid19_admission_detail 
(id,
member_id,
first_name,
middle_name,
last_name,
age,
contact_number,
address,
gender,
flight_no,
refer_from_hospital,

case_no,
unit_no,

is_cough,
is_fever,
is_breathlessness,
location_id,
covid19_lab_test_recommendation_id,
last_lab_test_id,
last_check_up_detail_id,
health_infra_id,
current_ward_id,
current_bed_no,
admission_status_id,
admission_date,
admission_entry_by,
admission_entry_on,
is_hiv,
is_heart_patient,
is_diabetes,
admission_from,
status,
pincode,
emergency_contact_name,
emergency_contact_no,
is_immunocompromized,
is_hypertension,
is_malignancy,
is_renal_condition,
is_copd,
pregnancy_status,
date_of_onset_symptom,
occupation,
travel_history,
travelled_place,
is_abroad_in_contact,
abroad_contact_details
)
values(
(select id from generated_id)
,#member_id#
,''#firstname#''
,(case when ''#middlename#'' = ''null'' then null else ''#middlename#'' end)
,(case when ''#lastname#'' = ''null'' then null else ''#lastname#'' end)
,#age#
,(case when ''#contact_no#'' = ''null'' then null else ''#contact_no#'' end)
,(case when ''#address#'' = ''null'' then null else ''#address#'' end)
,(case when ''#gender#'' = ''null'' then null else ''#gender#'' end)
,(case when ''#flightno#'' = ''null'' then null else ''#flightno#'' end)
,(case when ''#referFromHosital#'' = ''null'' then null else ''#referFromHosital#'' end)

,(case when ''#case_number#'' = ''null'' then null else ''#case_number#'' end)
,(case when ''#unitno#'' = ''null'' then null else ''#unitno#'' end)
,#hasCough#
,#hasFever#
,#hasShortnessBreath#
,''#districtLocationId#''
,#covid19_lab_test_recommendation_id#
,(select id from insert_lab_test)
,(select id from insert_daily_admission_det)
,(select id from health_infra_det)
,#ward_no#
,''#bed_no#''
,(select id from insert_daily_admission_det)
,''#admission_date#''
,#loggedIn_user#
,now()
,#isHIV#
,#isHeartPatient#
,#isDiabetes#
,''NEW''
,''SUSPECT''
,''#pinCode#''
,(case when ''#emergencyContactName#'' = ''null'' then null else ''#emergencyContactName#'' end)
,(case when ''#emergencyContactNo#'' = ''null'' then null else ''#emergencyContactNo#'' end)
,#isImmunocompromized#
,#isHypertension#
,#isMalignancy#
,#isRenalCondition#
,#isCOPD#
,(case when ''#pregnancy_status#'' = ''null'' then null else ''#pregnancy_status#'' end)
,''#date_of_onset_symptom#''
,(case when ''#occupation#'' = ''null'' then null else ''#occupation#'' end)
,(case when ''#travelHistory#'' = ''null'' then null else ''#travelHistory#'' end)
,(case when ''#travelledPlace#'' = ''null'' then null else ''#travelledPlace#'' end)
,(case when ''#is_abroad_in_contact#'' = ''null'' then null else ''#is_abroad_in_contact#'' end)
,(case when ''#abroad_contact_details#'' = ''null'' then null else ''#abroad_contact_details#'' end)
)
RETURNING id;', true, 'ACTIVE', 'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI 
JSON as input paramter', NULL);
