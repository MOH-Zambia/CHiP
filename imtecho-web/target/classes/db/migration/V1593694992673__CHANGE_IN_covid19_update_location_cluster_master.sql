DELETE FROM QUERY_MASTER WHERE CODE='covid19_update_location_cluster_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e0e153b9-a404-49bc-b06e-9d78cc28356a', 75398,  current_date , 75398,  current_date , 'covid19_update_location_cluster_master', 
'name,id,userId,population', 
'update location_cluster_master
set name = #name#,
population = #population#,
modified_by = #userId#,
modified_on = now()
where id = #id#;
delete from location_cluster_mapping_detail where cluster_id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_location_cluster_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ff09f991-f550-4f07-b2af-b0222958582d', 75398,  current_date , 75398,  current_date , 'covid19_insert_location_cluster_master', 
'name,userId,population', 
'insert into location_cluster_master
(name,state,population,created_by,created_on,modified_by,modified_on)
values(#name#,''ACTIVE'',#population#,#userId#,now(),#userId#,now())
returning id;', 
'', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_lab_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0d271a27-0ee6-4284-b384-b0d792aca410', 75398,  current_date , 75398,  current_date , 'covid19_retrieve_lab_location', 
'type', 
'select * 
from location_master 
where id in (select lhc.parent_id from location_hierchy_closer_det lhc where lhc.child_id in (
select location_id from health_infrastructure_details where is_covid_lab
) and lhc.parent_loc_type in (#type#)
)
order by name;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_covid_hospital_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4adcbd37-8bb0-4ca3-b039-0e89133e8e21', 75398,  current_date , 75398,  current_date , 'covid19_retrieve_covid_hospital_location', 
'type', 
'select * from location_master where type in (#type#) order by name', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_update_lab_test_result';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a3214b8f-42f2-440a-bea7-315fdc1a5bb2', 75398,  current_date , 75398,  current_date , 'emo_dashboard_update_lab_test_result', 
'result,loggedInUserId,id', 
'update covid19_lab_test_recommendation
set lab_test_status = #result#
, lab_test_status_entry_on = now()
,lab_test_status_entry_by = #loggedInUserId#
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid_19_save_only_lab_test_admission';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9ca0743e-599a-4c4f-a028-386d9637f109', 75398,  current_date , 75398,  current_date , 'covid_19_save_only_lab_test_admission', 
'otherCoMobidity,indications,occupation,isHypertension,emergencyContactNo,health_infra_id,abroad_contact_details,referFromHosital,opdCaseNo,admission_date,contact_no,case_number,health_status,memberId,isImmunocompromized,unitno,pregnancy_status,loggedInUserId,isCOPD,travelledPlace,lastname,hasShortnessBreath,pinCode,is_abroad_in_contact,suggestedHealthInfra,inContactWithCovid19Paitent,firstname,gender,bed_no,date_of_onset_symptom,isRenalCondition,isHeartPatient,labHealthInfraId,isOtherCoMobidity,flightno,locationId,member_id,address,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,middlename,travelHistory,collectionDate,isMalignancy,isMigrant,covid19_lab_test_recommendation_id,hasFever,isHIV,otherIndications,districtLocationId,isDiabetes,age,ageMonth', 
'create temp table lab_id_det (
lab_id integer
);

with generated_id as (
select  nextval(''covid19_admission_detail_id_seq'') as id
),health_infra_det as (
select id from health_infrastructure_details where #health_infra_id# is null and id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
union all
select cast(#health_infra_id# as integer) as id where  #health_infra_id# is not null
),insert_daily_admission_det as (
insert into covid19_admitted_case_daily_status(member_id,location_id,admission_id,service_date,ward_id,bed_no,health_status,created_by,created_on)
values(#member_id#,#districtLocationId#,(select id from generated_id),#admission_date#,#ward_no#,#bed_no#,#health_status#,#loggedInUserId#,now())
returning id
),insert_lab_test as (
INSERT INTO covid19_lab_test_detail(
member_id, location_id, covid_admission_detail_id, lab_collection_status,created_by,created_on,sample_health_infra,sample_health_infra_send_to,lab_collection_on,lab_collection_entry_by, collection_server_date)
VALUES (#memberId#,
#locationId#, (select id from generated_id),''SAMPLE_COLLECTED'',#loggedInUserId#,now(), (select id from health_infra_det),#labHealthInfraId#,to_timestamp(#collectionDate#,''DD/MM/YYYY HH24:MI:SS''),#loggedInUserId#, now())
returning id
),update_lab_test_recommdation as (
update covid19_lab_test_recommendation set admission_id = (select id from generated_id)
where id = #covid19_lab_test_recommendation_id#
),insert_lab_test_det_id as(
insert into lab_id_det(lab_id)
select id from insert_lab_test
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
suggested_health_infra,
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
,#ward_no#
,(case when #bed_no# = null then null else #bed_no# end)
,(select id from insert_daily_admission_det)
,#admission_date#
,#loggedIn_user#
,now()
,#isHIV#
,#isHeartPatient#
,#isDiabetes#
,''OPD_ADMIT''
,''OPD_ADMIT''
,#pinCode#
,(case when #emergencyContactName# = null then null else #emergencyContactName# end)
,(case when #emergencyContactNo# = null then null else #emergencyContactNo# end)
,#isImmunocompromized#
,#isHypertension#
,#isMalignancy#
,#isRenalCondition#
,#isCOPD#
,(case when #pregnancy_status# = null then null else #pregnancy_status# end)
,(case when #date_of_onset_symptom# = null then null else to_date(#date_of_onset_symptom#,''MM-DD-YYYY'') end)
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
,#suggestedHealthInfra#
,#isMigrant#);
update covid19_lab_test_detail set created_by = created_by where id = (select lab_id from lab_id_det);', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_lab_infrastructure_kit_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'259a2728-c74c-42fe-a9c3-59ad47d4dd16', 75398,  current_date , 75398,  current_date , 'covid19_insert_lab_infrastructure_kit_details', 
'healthInfraId,receiptDate,receivedFrom,kitsList,userId', 
'insert into covid19_lab_infrastructure_kit_history
(health_infra_id,receipt_date,received_from,list_of_kits,created_by,created_on,modified_by,modified_on)
values(#healthInfraId#,#receiptDate#,#receivedFrom#,#kitsList#,#userId#,now(),#userId#,now());', 
null, 
false, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='covid19_component_details_by_date_and_infra';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e1cd218d-3059-464b-9b1a-b6b89523b010', 75398,  current_date , 75398,  current_date , 'covid19_component_details_by_date_and_infra', 
'healthInfraId,receiptDate', 
'select *
from covid19_lab_infrastructure_component_history
where health_infra_id = #healthInfraId#
and receipt_date = #receiptDate#;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_insert_lab_infrastructure_component_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ca5d0a1e-d478-4f65-a63d-d1ae0f5813fa', 75398,  current_date , 75398,  current_date , 'covid19_insert_lab_infrastructure_component_details', 
'healthInfraId,eg,confirmatoryAssay,testCapacity,receiptDate,agPath,userId,rnaExtraction', 
'insert into covid19_lab_infrastructure_component_history
(health_infra_id,receipt_date,rna_extraction,eg_available,confirmatory_assay,ag_path,test_capacity,created_by,created_on,modified_by,modified_on)
values(#healthInfraId#,#receiptDate#,#rnaExtraction#,#eg#,#confirmatoryAssay#,#agPath#,#testCapacity#,#userId#,now(),#userId#,now());', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_save_sample_collection';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fa38a80a-9742-4b4b-9d3b-13ccd3466046', 75398,  current_date , 75398,  current_date , 'lab_test_dashboard_save_sample_collection', 
'healthInfraId,id,collectionDate,userId', 
'update covid19_lab_test_detail
set sample_health_infra_send_to = case when #healthInfraId# = null then sample_health_infra else #healthInfraId# end,
lab_collection_on = #collectionDate#,
lab_collection_entry_by = #userId#,
lab_collection_status = ''SAMPLE_COLLECTED'',
collection_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_sample_received_status';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1b605f3c-ea8e-4722-93e6-13e01fdf1e7f', 75398,  current_date , 75398,  current_date , 'lab_test_dashboard_mark_sample_received_status', 
'receiveDate,rejectionRemarks,labTestNumber,rejectionRemarkSelected,id,userId,status', 
'update covid19_lab_test_detail
set lab_collection_status = #status#,
lab_sample_rejected_by = case when #status# = ''SAMPLE_REJECTED'' then #userId# else null end,
lab_sample_rejected_on = case when #status# = ''SAMPLE_REJECTED'' then to_timestamp(#receiveDate#,''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_sample_reject_reason = #rejectionRemarks#,
lab_sample_received_by = case when #status# = ''SAMPLE_ACCEPTED'' then #userId# else null end,
lab_sample_received_on = case when #status# = ''SAMPLE_ACCEPTED'' then to_timestamp(#receiveDate#,''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_test_number = case when #status# = ''SAMPLE_ACCEPTED'' then #labTestNumber# else null end,
rejection_remark_selected = (case when #rejectionRemarkSelected# = ''null'' then null else #rejectionRemarkSelected# end),
receive_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lab_test_insert_transfer_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'98b90f9a-a4ae-489f-8e1f-a41462b15a8c', 75398,  current_date , 75398,  current_date , 'lab_test_insert_transfer_history', 
'healthInfraTo,labTestId,transferDate,healthInfraFrom,userId', 
'insert into covid19_lab_test_transfer_history
(lab_test_id,health_infra_from,health_infra_to,transferred_on,transfer_server_date,transferred_by)
values(#labTestId#,#healthInfraFrom#,#healthInfraTo#,to_timestamp(#transferDate#,''DD/MM/YYYY HH24:MI:SS''),now(),#userId#);', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_result_status';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'be70361d-62c5-41bb-b91f-ee87a76acd0b', 75398,  current_date , 75398,  current_date , 'lab_test_dashboard_mark_result_status', 
'result,otherResultRemarksSelected,resultDate,labName,isRecollect,id,userId,resultRemarks', 
'with admission_det as (
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id# and #result# = ''POSITIVE''
),update_admission_status as (
update covid19_admission_detail
set status = ''CONFORMED'' where id = (select admission_id from admission_det) and #result# = ''POSITIVE'' and discharge_status is null
)
update covid19_lab_test_detail
set lab_result_entry_on = to_timestamp(#resultDate#,''DD/MM/YYYY HH24:MI:SS''),
lab_result_entry_by = #userId#,
lab_result = #result#,
lab_collection_status = #result#,
indeterminate_lab_name = (case when #labName# = null then indeterminate_lab_name else #labName# end),
result_remarks = (case when #resultRemarks# = null then null else #resultRemarks# end),
is_recollect = #isRecollect#,
other_result_remarks_selected = (case when #otherResultRemarksSelected# = null then null else #otherResultRemarksSelected# end),
result_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_edit_lab_result';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'da31b1a0-c013-4612-9d17-32da83a96905', 75398,  current_date , 75398,  current_date , 'covid19_edit_lab_result', 
'result,otherResultRemarksSelected,resultDate,labName,isRecollect,id,userId,resultRemarks', 
'with admission_det as ( 
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id#
),sample_count_det as(
select count(1) as sample_count from covid19_lab_test_detail cltd where cltd.covid_admission_detail_id = (select admission_id from admission_det) 
),update_admission_status as (
update covid19_admission_detail
set status = (case when scd.sample_count = 1 and #result# = ''POSITIVE'' then ''CONFORMED''
when scd.sample_count = 1 then ''SUSPECTED''
else status end)
from sample_count_det scd
where id = (select admission_id from admission_det) and status in (''CONFORMED'',''SUSPECTED'')
)
update covid19_lab_test_detail
set lab_result_entry_on = to_timestamp(#resultDate#,''DD/MM/YYYY HH24:MI:SS''),
lab_result_entry_by = #userId#,
lab_result = #result#,
lab_collection_status = #result#,
indeterminate_lab_name = (case when #labName# = null then indeterminate_lab_name else #labName# end),
result_remarks = (case when #resultRemarks# = null then null else #resultRemarks# end),
is_recollect = #isRecollect#,
other_result_remarks_selected = (case when #otherResultRemarksSelected# = null then null else #otherResultRemarksSelected# end),
result_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');