DELETE FROM QUERY_MASTER WHERE CODE='insert_covid19_new_admission_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8201f0fd-c01a-4610-ae0d-1a32e3e782b1', 74840,  current_date , 74840,  current_date , 'insert_covid19_new_admission_detail',
'otherCoMobidity,indications,occupation,isHypertension,emergencyContactNo,abroad_contact_details,referFromHosital,opdCaseNo,admission_date,contact_no,case_number,health_status,memberId,isImmunocompromized,unitno,pregnancy_status,loggedInUserId,isCOPD,travelledPlace,lastname,hasShortnessBreath,pinCode,is_abroad_in_contact,inContactWithCovid19Paitent,firstname,gender,bed_no,date_of_onset_symptom,isRenalCondition,isHeartPatient,isOtherCoMobidity,flightno,locationId,member_id,address,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,middlename,travelHistory,isMalignancy,isMigrant,covid19_lab_test_recommendation_id,hasFever,isHIV,otherIndications,districtLocationId,isDiabetes,age,ageMonth',
'with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id
),health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#districtLocationId#,(select id from generated_id),#admission_date#,#ward_no#,#bed_no#,#health_status#,#loggedInUserId#,now())
returning id
),insert_lab_test as (
INSERT INTO covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra)
VALUES (#memberId#,
#locationId#, (select id from generated_id),''COLLECTION_PENDING'',#loggedInUserId#,now(), (select id from health_infra_det))
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
age_month,
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
abroad_contact_details,

in_contact_with_covid19_paitent,
opd_case_no,
is_other_co_mobidity,
other_co_mobidity,
is_sari,
indications,
indication_other,
is_migrant
)
values(
(select id from generated_id)
,#member_id#
,#firstname#
,(case when #middlename# = null then null else #middlename# end)
,(case when #lastname# = null then null else #lastname# end)
,#age#
,#ageMonth#
,(case when #contact_no# = null then null else #contact_no# end)
,(case when #address# = null then null else #address# end)
,(case when #gender# = null then null else #gender# end)
,(case when #flightno# = null then null else #flightno# end)
,(case when #referFromHosital# = null then null else #referFromHosital# end)

,(case when #case_number# = null then null else #case_number# end)
,(case when #unitno# = null then null else #unitno# end)
,#hasCough#
,#hasFever#
,#hasShortnessBreath#
,#districtLocationId#
,#covid19_lab_test_recommendation_id#
,(select id from insert_lab_test)
,(select id from insert_daily_admission_det)
,(select id from health_infra_det)
,#ward_no#
,#bed_no#
,(select id from insert_daily_admission_det)
,#admission_date#
,#loggedIn_user#
,now()
,#isHIV#
,#isHeartPatient#
,#isDiabetes#
,''NEW''
,''SUSPECT''
,(case when #pinCode# = null then null else #pinCode# end)
,(case when #emergencyContactName# = null then null else #emergencyContactName# end)
,(case when #emergencyContactNo# = null then null else #emergencyContactNo# end)
,#isImmunocompromized#
,#isHypertension#
,#isMalignancy#
,#isRenalCondition#
,#isCOPD#
,(case when #pregnancy_status# = null then null else #pregnancy_status# end)
,(case when #date_of_onset_symptom# = null then null else cast(#date_of_onset_symptom# as date) end)
,(case when #occupation# = null then null else #occupation# end)
,(case when #travelHistory# = null then null else #travelHistory# end)
,(case when #travelledPlace# = null then null else #travelledPlace# end)
,(case when #is_abroad_in_contact# = null then null else #is_abroad_in_contact# end)
,(case when #abroad_contact_details# = null then null else #abroad_contact_details# end)

,(case when #inContactWithCovid19Paitent# = null then null else #inContactWithCovid19Paitent# end)
,(case when #opdCaseNo# = null then null else #opdCaseNo# end)
,#isOtherCoMobidity#
,(case when #otherCoMobidity# = null then null else #otherCoMobidity# end)
,#isSari#
,(case when #indications# = null then null else #indications# end)
,(case when #otherIndications# = null then null else #otherIndications# end)
,#isMigrant#
)
RETURNING id;',
'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI
JSON as input paramter',
true, 'ACTIVE');