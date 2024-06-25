drop table if exists covid19_lab_test_transfer_history;

create table covid19_lab_test_transfer_history
(
	id serial primary key,
	lab_test_id integer not null,
	health_infra_from integer not null,
	health_infra_to integer not null,
	transferred_on timestamp without time zone not null,
	transfer_server_date timestamp without time zone not null,
	transferred_by integer not null
);

alter table covid19_lab_test_detail
drop column if exists is_transferred,
add column is_transferred boolean;

update menu_config
set feature_json = '{"canSampleCollect" : false, "canSampleReceive" : false, "canSampleResult" : false,"canIndeterminate":false,"canTransfer":false}'
where menu_name = 'Lab';

delete from QUERY_MASTER where CODE='lab_test_insert_transfer_history';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_insert_transfer_history',
'healthInfraTo,labTestId,transferDate,healthInfraFrom,userId',
'insert into covid19_lab_test_transfer_history
(lab_test_id,health_infra_from,health_infra_to,transferred_on,transfer_server_date,transferred_by)
values(#labTestId#,#healthInfraFrom#,#healthInfraTo#,to_timestamp(''#transferDate#'',''DD/MM/YYYY HH24:MI:SS''),now(),#userId#);',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='lab_test_transfer_update';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_transfer_update',
'healthInfraTo,labTestId',
'update covid19_lab_test_detail
set sample_health_infra_send_to = #healthInfraTo#,
is_transferred = true
where id = #labTestId#;',
null,
false, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_lab_test_pending_sample_receive';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_receive',
'limit_offset,loggedInUserId',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_collection_on as collection_date,
	ltd.sample_health_infra_send_to as health_infra_to,
	ltd.is_transferred as is_transferred,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Year'') as age,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	hiwd.ward_name,
	sample_from."name" as sample_from_health_infra,
	sample_from.is_covid_lab,
	clt.current_ward_id as ward_id,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	clt.is_hiv as hiv,
	clt.current_bed_no,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_COLLECTED''
	order by ltd.lab_collection_on
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,collection_date as "sampleCollectionDate"
,health_infra_to as "healthInfraTo"
,is_transferred as "isTransferred"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,hiv
,sample_from_health_infra as "sampleFrom"
,is_covid_lab as "isSameHealthInfrastructure"
from idsp_screening;',
null,
true, 'ACTIVE');

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
concat(emergency_contact_name,'' ('',emergency_contact_no,'')'') as "emergencyDetails",
health_infrastructure_details.name as "admittedHospital"
from covid19_admission_detail
left join health_infrastructure_details on covid19_admission_detail.health_infra_id = health_infrastructure_details.id
where id = #admissionId#',
null,
true, 'ACTIVE');