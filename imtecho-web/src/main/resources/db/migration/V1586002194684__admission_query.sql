alter table covid19_admitted_case_daily_status
drop column if exists temperature ,   
drop column if exists pulse_rate ,
drop column if exists bp_systolic ,
drop column if exists bp_dialostic ,
drop column if exists respiration_rate ,
drop column if exists spo2 ,

drop column if exists azithromycin ,
drop column if exists hydroxychloroquine ,
drop column if exists oseltamivir ,
drop column if exists antibiotics ,

drop column if exists is_xray ,
drop column if exists xray_detail ,
drop column if exists is_ctscan ,
drop column if exists ct_scan_detail ,
drop column if exists is_ecg ,
drop column if exists ecg_detail ,
drop column if exists is_serum_creatinine ,
drop column if exists serum_creatinine_detail ,
drop column if exists is_sgpt ,
drop column if exists sgpt_detail ,
drop column if exists is_h1n1_test ,
drop column if exists h1n1_test_detail ,
drop column if exists blood_culture ,
drop column if exists blood_culture_detail ,
drop column if exists is_g6pd ,
drop column if exists g6pd_detail ,

add column temperature integer,   
add column pulse_rate integer,
add column bp_systolic integer,
add column bp_dialostic integer,
add column respiration_rate integer,
add column spo2 integer,

add column azithromycin boolean,
add column hydroxychloroquine boolean,
add column oseltamivir boolean,
add column antibiotics boolean,

add column is_xray boolean,
add column xray_detail text,
add column is_ctscan boolean,
add column ct_scan_detail text,
add column is_ecg boolean,
add column ecg_detail text,
add column is_serum_creatinine boolean,
add column serum_creatinine_detail text,
add column is_sgpt boolean,
add column sgpt_detail text,
add column is_h1n1_test boolean,
add column h1n1_test_detail text,
add column blood_culture boolean,
add column blood_culture_detail text,
add column is_g6pd boolean,
add column g6pd_detail text;


alter table covid19_admission_detail
drop column if exists indication_other ,   
add column indication_other text;

DELETE FROM QUERY_MASTER WHERE CODE='insert_covid19_new_admission_detail';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
80248,  current_date , 80248,  current_date , 'insert_covid19_new_admission_detail', 
'otherCoMobidity,indications,occupation,isHypertension,emergencyContactNo,abroad_contact_details,referFromHosital,opdCaseNo,admission_date,contact_no,case_number,health_status,memberId,isImmunocompromized,unitno,pregnancy_status,loggedInUserId,isCOPD,travelledPlace,lastname,hasShortnessBreath,pinCode,is_abroad_in_contact,inContactWithCovid19Paitent,firstname,gender,bed_no,date_of_onset_symptom,isRenalCondition,isHeartPatient,isOtherCoMobidity,flightno,locationId,member_id,address,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,middlename,travelHistory,isMalignancy,covid19_lab_test_recommendation_id,hasFever,isHIV,otherIndications,districtLocationId,isDiabetes,age', 
'with generated_id as (
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
abroad_contact_details,

in_contact_with_covid19_paitent,
opd_case_no,
is_other_co_mobidity,
other_co_mobidity,
is_sari,
indications,
indication_other
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

,(case when ''#inContactWithCovid19Paitent#'' = ''null'' then null else ''#inContactWithCovid19Paitent#'' end)
,(case when ''#opdCaseNo#'' = ''null'' then null else ''#opdCaseNo#'' end)
,#isOtherCoMobidity#
,(case when ''#otherCoMobidity#'' = ''null'' then null else ''#otherCoMobidity#'' end)
,#isSari#
,(case when ''#indications#'' = ''null'' then null else ''#indications#'' end)
,(case when ''#otherIndications#'' = ''null'' then null else ''#otherIndications#'' end)
)
RETURNING id;', 
'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI 
JSON as input paramter', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_addmitted_case_daily_status_insert_data';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_addmitted_case_daily_status_insert_data', 
'otherCoMobidity,temprature,isSerum,isECG,serviceDate,cTScanImpression,G6PDImpression,ventilatorType2,ventilatorType1,isHypertension,serumCreatinineImpression,isG6PD,hydroxychloroquine,bedNumber,bpDialostic,memberId,isImmunocompromized,onAir,h1N1TestImpression,sp02,azithromycin,isSGPT,wardId,loggedInUserId,isCOPD,hasShortnessBreath,healthStatus,xRAYImpression,antibiotics,isRenalCondition,isHeartPatient,isOtherCoMobidity,respirationRate,isH1N1,locationId,onO2,bloodCultureImpression,isXray,bpSystolic,isSari,sGPTImpression,hasCough,eCGImpression,isMalignancy,isBlood,hasFever,onVentilator,isHIV,pulseRate,admissionId,oseltamivir,isDiabetes,clinicallyCured,remarks,isCtScan', 
'with insert_daily_check_up as (
insert into covid19_admitted_case_daily_status(member_id,
location_id,
admission_id,
service_date,
ward_id,
bed_no,
health_status,
on_ventilator,
ventilator_type1,
ventilator_type2,
on_o2,
on_air,
clinically_clear,
remarks,
created_by,
created_on,

temperature,   
pulse_rate,
bp_systolic,
bp_dialostic,
respiration_rate,
spo2,

azithromycin,
hydroxychloroquine,
oseltamivir,
antibiotics,

is_xray,
xray_detail,
is_ctscan,
ct_scan_detail,
is_ecg,
ecg_detail,
is_serum_creatinine,
serum_creatinine_detail,
is_sgpt,
sgpt_detail,
is_h1n1_test,
h1n1_test_detail,
blood_culture,
blood_culture_detail,
is_g6pd,
g6pd_detail)
values(
#memberId#,
''#locationId#'',
''#admissionId#'',
''#serviceDate#''
,''#wardId#''
,''#bedNumber#''
,''#healthStatus#''
, #onVentilator#
,#ventilatorType1#
,#ventilatorType2#
,#onO2#
,#onAir#
,#clinicallyCured#
,''#remarks#''
,''#loggedInUserId#''
,now()

,#temprature#,
#pulseRate#,
#bpSystolic#,
#bpDialostic#,
#respirationRate#,
#sp02#,

#azithromycin#,
#hydroxychloroquine#,
#oseltamivir#,
#antibiotics#,

#isXray#,
(case when ''#xRAYImpression#'' = ''null'' then null else ''#xRAYImpression#'' end),
#isCtScan#,
(case when ''#cTScanImpression#'' = ''null'' then null else ''#cTScanImpression#'' end),
#isECG#,
(case when ''#eCGImpression#'' = ''null'' then null else ''#eCGImpression#'' end),
#isSerum#,
(case when ''#serumCreatinineImpression#'' = ''null'' then null else ''#serumCreatinineImpression#'' end),
#isSGPT# ,
(case when ''#sGPTImpression#'' = ''null'' then null else ''#sGPTImpression#'' end),
#isH1N1#,
(case when ''#h1N1TestImpression#'' = ''null'' then null else ''#h1N1TestImpression#'' end),
#isBlood#,
(case when ''#bloodCultureImpression#'' = ''null'' then null else ''#bloodCultureImpression#'' end),
#isG6PD#,
(case when ''#G6PDImpression#'' = ''null'' then null else ''#G6PDImpression#'' end)
)
returning id
)
update covid19_admission_detail cad set current_ward_id = ''#wardId#'', current_bed_no = ''#bedNumber#'' , last_check_up_detail_id = (select id from insert_daily_check_up),
is_cough=#hasCough#,
is_fever=#hasFever#,
is_breathlessness=#hasShortnessBreath#,
is_sari=#isSari#,
is_copd=#isCOPD#,
is_diabetes=#isDiabetes#,
is_hiv=#isHIV#,
is_heart_patient=#isHeartPatient#,
is_hypertension=#isHypertension#,
is_renal_condition=#isRenalCondition#,
is_immunocompromized=#isImmunocompromized#,
is_malignancy=#isMalignancy#,
is_other_co_mobidity=#isOtherCoMobidity#,
other_co_mobidity=''#otherCoMobidity#''
where id = #admissionId#;', 
null, 
false, 'ACTIVE');