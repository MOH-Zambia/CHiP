alter table covid19_admission_detail
drop column if exists in_contact_with_covid19_paitent,
drop column if exists opd_case_no,
drop column if exists is_other_co_mobidity,
drop column if exists other_co_mobidity,
drop column if exists is_sari,
add column in_contact_with_covid19_paitent text,
add column opd_case_no text,
add column is_other_co_mobidity boolean,
add column other_co_mobidity text,
add column is_sari boolean;

DELETE FROM QUERY_MASTER WHERE CODE='insert_covid19_new_admission_detail';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
80248,  current_date , 80248,  current_date , 'insert_covid19_new_admission_detail', 
'inContactWithCovid19Paitent,otherCoMobidity,firstname,occupation,gender,bed_no,date_of_onset_symptom,isHypertension,isRenalCondition,emergencyContactNo,isHeartPatient,isOtherCoMobidity,abroad_contact_details,flightno,referFromHosital,opdCaseNo,admission_date,locationId,contact_no,case_number,health_status,memberId,isImmunocompromized,member_id,address,unitno,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,pregnancy_status,middlename,travelHistory,loggedInUserId,isCOPD,travelledPlace,lastname,isMalignancy,hasShortnessBreath,covid19_lab_test_recommendation_id,hasFever,isHIV,districtLocationId,pinCode,is_abroad_in_contact,isDiabetes,age', 
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
is_sari
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
)
RETURNING id;', 
'This query will insert new record into data base for new covid 19 patient Query must be corrected to map with UI 
JSON as input paramter', 
true, 'ACTIVE');


update menu_config set feature_json = '{"isShowReferredAdmissionTab":false,
"isShowSuspectAdmittedCasesTab":false,
"isShowConfirmedAdmittedCasesTab":false,
"isShowAdmitButton":false,
"isShowCheckUpButton":false,
"isShowDischargeButton":false,
"isShowNewAdmissionButton":false,
"isShowReferInTab":false,
"isShowReferOutTab":false,
"isShowReferInAdmitButton":false}'
where menu_name = 'COVID-19 Admission' and navigation_state = 'techo.manage.covidAdmission';

DELETE FROM QUERY_MASTER WHERE CODE='covid19_admission_discharge';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admission_discharge', 
'tohealthInfraId,isDeath,isReferedToAnotherHospital,dischargeDate,deathDate,admissionId,loggedInUserId,deathCause,isDischarge', 
'with  death_state as (
update covid19_admission_detail set status = ''DEATH'',
death_cause = ''#deathCause#'',
discharge_date =to_date(''#deathDate#'',''YYYY-MM-DD''),
discharge_status =''DEATH'',
discharge_entry_by =''#loggedInUserId#'',
discharge_entry_on =now()
where id = #admissionId# and #isDeath# = true
),
health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
),
refer_to_helth_infra as(
insert into covid19_admission_refer_detail (admission_id, refer_from_health_infra_id,refer_to_health_infra_id,state,created_by,created_on)
select #admissionId#, (select id from health_infra_det), ''#tohealthInfraId#'', ''PENDING'', ''#loggedInUserId#'', now() 
where #isReferedToAnotherHospital# = true
),
update_admission_status as(
update covid19_admission_detail set status = ''REFER''
where id = #admissionId# and #isReferedToAnotherHospital# = true
)
update covid19_admission_detail set status = ''DISCHARGE'',
discharge_date =to_date(''#dischargeDate#'',''YYYY-MM-DD''),
discharge_status =''DISCHARGE'',
discharge_entry_by =''#loggedInUserId#'',
discharge_entry_on =now()
where id = #admissionId# and #isDischarge# = true;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_refer_in_admit';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_refer_in_admit', 
'unitNo,bedNo,admissionId,wardId,loggedInUser', 
'update covid19_admission_refer_detail set
state=''COMPLETED'',
modified_by=''#loggedInUser#'',
modified_on=now()
where admission_id = ''#admissionId#'';

update covid19_admission_detail set 
current_ward_id = ''#wardId#'',
current_bed_no=''#bedNo#'',
unit_no = ''#unitNo#'',
health_infra_id = (select refer_to_health_infra_id from covid19_admission_refer_detail where admission_id = ''#admissionId#''),
status = ''CONFORMED''
where id = ''#admissionId#'';', 
null, 
false, 'ACTIVE');


-- Drop table

DROP TABLE if exists covid19_admission_refer_detail;

CREATE TABLE covid19_admission_refer_detail (
	id serial NOT NULL,
	admission_id int4 NULL,
	refer_from_health_infra_id int4 NULL,
	refer_to_health_infra_id int4 NULL,
	state varchar(250) NULL,
	created_by int4 NULL,
	created_on timestamp NULL,
	modified_by int4 NULL,
	modified_on timestamp NULL,
	CONSTRAINT covid19_admission_refer_detail_pkey PRIMARY KEY (id)
);


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_refer_in_patient_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_get_refer_in_patient_list', 
'limit_offset,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null 
		then clt.age
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' Year'') as dob,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.current_bed_no,
	cltd.lab_collection_status as test_result,
	(case when cltd.lab_collection_status in (''COLLECTION_PENDING'',''SAMPLE_COLLECTED'',''SAMPLE_ACCEPTED'') then true else false end) as "isLabTestInProgress",
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_admission_detail clt
	inner join covid19_admission_refer_detail card on clt.id = card.admission_id and card.state = ''PENDING''
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	card.refer_to_health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status in (''REFER'')
	order by cacd.service_date
	#limit_offset#
)
select 
id as "admissionId" 
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,dob as "DOB"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,test_result as "testResult"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
from idsp_screening;', 
null, 
true, 'ACTIVE');
