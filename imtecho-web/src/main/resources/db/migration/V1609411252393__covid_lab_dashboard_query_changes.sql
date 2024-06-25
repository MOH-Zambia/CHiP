DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_collection';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f5d95f85-43be-4b91-b607-b2bd19d3036f', 60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_collection',
'searchText,offset,healthInfra,limit,loggedInUserId,wardId,collectionDate',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_test_number as lab_test_number,
	ltd.lab_collection_status as lab_collection_status,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Years'') as age,
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
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96))
	or ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	)
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status in (''COLLECTION_PENDING'',''SAMPLE_COLLECTED'')
	and collection_archive is not true
	and (case when #searchText# != ''null'' and #searchText# != '''' then ltd.search_text ilike concat(''%'',#searchText#,''%'') else true end)
	and (case when #healthInfra# != ''null'' and #healthInfra# != '''' then sample_from.name_in_english ilike concat(''%'',#healthInfra#,''%'') else true end)
	and (case when #collectionDate# != ''null'' and #collectionDate# != '''' then to_char(ltd.lab_collection_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when #wardId# != ''null'' and #wardId# != '''' then hiwd.ward_name = #wardId# else true end)
	order by ltd.created_on desc
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_id as "labTestId"
,lab_test_number as "labTestNumber"
,lab_collection_status as "labCollectionStatus"
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

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_collection_all';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b0208bf1-c354-4758-bb05-7b44c3dc81e5', 60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_collection_all',
'searchText,healthInfra,loggedInUserId,wardId,collectionDate',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_test_number as lab_test_number,
	clt.location_id as loc_id,
	imt_member.id as member_id,
	case when clt.member_id is null
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , ''<br>'' , imt_member.family_id) end as member_det,
	concat(case when clt.member_id is null
		then cast(clt.age as text)
		else cast(EXTRACT(YEAR FROM age(imt_member.dob)) as text) end,'' Years'') as age,
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
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96))
	or ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''COLLECTION_PENDING''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	and (case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end)
	and (case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end)
	and (case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_collection_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when ''#wardId#'' != ''null'' and ''#wardId#'' != '''' then hiwd.ward_name = ''#wardId#'' else true end)
	order by cacd.service_date desc
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_id as "labTestId"
,lab_test_number as "labTestNumber"
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

DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_admission_details';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b4d32480-36b4-4e8f-b7a0-e55e5895158c', 60512,  current_date , 60512,  current_date , 'covid19_retrieve_admission_details',
'admissionId',
'select get_location_hierarchy(covid19_admission_detail.location_id) as "location",
covid19_admission_detail.address as "address",
pincode as "pincode",
occupation as "occupation",
travel_history as "travelHistory",
is_abroad_in_contact as "abroadContact",
in_contact_with_covid19_paitent as "covidPositiveContact",
case_no as "caseNumber",
opd_case_no as "opdCaseNumber",
covid19_admission_detail.contact_number as "contactNumber",
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
emergency_contact_name as "emergencyContactName",
emergency_contact_no as "emergencyContactNumber",
health_infrastructure_details.name as "admittedHospital"
from covid19_admission_detail
left join health_infrastructure_details on covid19_admission_detail.health_infra_id = health_infrastructure_details.id
where covid19_admission_detail.id = #admissionId#',
null,
true, 'ACTIVE');