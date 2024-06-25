DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_only_lab_test_admission';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ce8adad7-1fc7-4432-8b16-65437d7d4e97', 80208,  current_date , 80208,  current_date , 'covid_19_get_opd_only_lab_test_admission', 
'searchText,offset,limit,loggedInUserId', 
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
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' years'') as dob,
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
	cacd.service_date as last_check_up_time,
	clt.is_hiv,
	clt.is_heart_patient,
	clt.is_diabetes ,
	clt.is_copd,
	clt.is_renal_condition,
	clt.is_hypertension,
	clt.is_immunocompromized,
	clt.is_malignancy,
	clt.is_other_co_mobidity,
	clt.other_co_mobidity,
	clt.is_fever,
	clt.is_cough,
	clt.is_breathlessness,
	clt.is_sari,
    cltd.id as lab_test_id,
    cltd.lab_test_id as lab_id
	from covid19_admission_detail clt
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	cltd.sample_health_infra in (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.admission_from in (''OPD_ADMIT'')
	and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cltd.created_on desc
	limit #limit# offset #offset#
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
,on_ventilator as "onVentilator"
,ventilator_type1 as "ventilatorType1"
,ventilator_type2 as "ventilatorType2"
,on_o2 as "onO2"
,on_air as "onAir"
,remarks
,"isLabTestInProgress"
,is_hiv as "isHIV"
,is_heart_patient as "isHeartPatient"
,is_diabetes as "isDiabetes"
,is_copd as "isCOPD"
,is_renal_condition as "isRenalCondition"
,is_hypertension as "isHypertension"
,is_immunocompromized as "isImmunocompromized"
,is_malignancy as "isMalignancy"
,is_other_co_mobidity as "isOtherCoMobidity"
,other_co_mobidity as "otherCoMobidity"
,is_fever as "hasFever"
,is_cough as "hasCough"
,is_breathlessness as "hasShortnessBreath"
,is_sari as "isSari"
,lab_test_id as "labTestId"
,lab_id as "labTestIdFromLabTest"
from idsp_screening;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_result_status';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'be70361d-62c5-41bb-b91f-ee87a76acd0b', 80240,  current_date , 80240,  current_date , 'lab_test_dashboard_mark_result_status', 
'result,otherResultRemarksSelected,resultDate,labName,isRecollect,id,userId,resultRemarks', 
'with admission_det as (
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id# and #result# = ''POSITIVE''
),update_admission_status as (
update covid19_admission_detail
set status = ''CONFORMED'' where id = (select admission_id from admission_det) and #result# = ''POSITIVE'' and discharge_status is null
)
update covid19_lab_test_detail
set lab_result_entry_on = cast(#resultDate# as timestamp),
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

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_result';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c6185ad1-c6e0-4291-b524-db3280e20443', 80240,  current_date , 80240,  current_date , 'covid19_lab_test_pending_sample_result', 
'searchText,limit_offset,offset,healthInfra,limit,loggedInUserId,wardId,collectionDate', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.lab_sample_received_on as receive_date,
	ltd.lab_test_id as lab_test_id,
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
	sample_from.name_in_english as sample_from_health_infra,
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
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_ACCEPTED''
--	and (case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end)
	and ltd.search_text ilike concat(''%'',#searchText#,''%'')
	and (case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end)
--	and (case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_sample_received_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when #collectionDate# != null and #collectionDate# != '''''''' then cast(ltd.lab_collection_on as date) = #collectionDate# else true end)
	and (case when ''#wardId#'' != ''null'' and ''#wardId#'' != '''' then hiwd.ward_name = ''#wardId#'' else true end)
	order by ltd.receive_server_date desc
--	#limit_offset#
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,receive_date as "sampleReceiveDate"
,lab_test_id as "labTestId"
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
,cast(''CONFIRMATION'' as text) as "resultStage"
from idsp_screening', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_only_lab_test_admission';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ce8adad7-1fc7-4432-8b16-65437d7d4e97', 80208,  current_date , 80208,  current_date , 'covid_19_get_opd_only_lab_test_admission', 
'searchText,offset,limit,loggedInUserId', 
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
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' years'') as dob,
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
	cacd.service_date as last_check_up_time,
	clt.is_hiv,
	clt.is_heart_patient,
	clt.is_diabetes ,
	clt.is_copd,
	clt.is_renal_condition,
	clt.is_hypertension,
	clt.is_immunocompromized,
	clt.is_malignancy,
	clt.is_other_co_mobidity,
	clt.other_co_mobidity,
	clt.is_fever,
	clt.is_cough,
	clt.is_breathlessness,
	clt.is_sari,
    cltd.id as lab_test_id,
    cltd.lab_test_id as lab_id
	from covid19_admission_detail clt
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	cltd.sample_health_infra in (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.admission_from in (''OPD_ADMIT'')
	and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cltd.created_on desc
	limit #limit# offset #offset#
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
,on_ventilator as "onVentilator"
,ventilator_type1 as "ventilatorType1"
,ventilator_type2 as "ventilatorType2"
,on_o2 as "onO2"
,on_air as "onAir"
,remarks
,"isLabTestInProgress"
,is_hiv as "isHIV"
,is_heart_patient as "isHeartPatient"
,is_diabetes as "isDiabetes"
,is_copd as "isCOPD"
,is_renal_condition as "isRenalCondition"
,is_hypertension as "isHypertension"
,is_immunocompromized as "isImmunocompromized"
,is_malignancy as "isMalignancy"
,is_other_co_mobidity as "isOtherCoMobidity"
,other_co_mobidity as "otherCoMobidity"
,is_fever as "hasFever"
,is_cough as "hasCough"
,is_breathlessness as "hasShortnessBreath"
,is_sari as "isSari"
,lab_test_id as "labTestId"
,lab_id as "labTestIdFromLabTest"
from idsp_screening;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_result';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c6185ad1-c6e0-4291-b524-db3280e20443', 80240,  current_date , 80240,  current_date , 'covid19_lab_test_pending_sample_result', 
'searchText,limit_offset,offset,healthInfra,limit,loggedInUserId,wardId,collectionDate', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.lab_sample_received_on as receive_date,
	ltd.lab_test_id as lab_test_id,
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
	sample_from.name_in_english as sample_from_health_infra,
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
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_ACCEPTED''
--	and (case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end)
	and ltd.search_text ilike concat(''%'',#searchText#,''%'')
	and (case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end)
--	and (case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_sample_received_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when #collectionDate# != null and #collectionDate# != '''''''' then cast(ltd.lab_collection_on as date) = #collectionDate# else true end)
	and (case when ''#wardId#'' != ''null'' and ''#wardId#'' != '''' then hiwd.ward_name = ''#wardId#'' else true end)
	order by ltd.receive_server_date desc
--	#limit_offset#
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,receive_date as "sampleReceiveDate"
,lab_test_id as "labTestId"
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
,cast(''CONFIRMATION'' as text) as "resultStage"
from idsp_screening', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_indeterminate';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1ff2ec19-23a4-4eb6-9c5c-4d1e2bfa85e9', 80240,  current_date , 80240,  current_date , 'lab_test_dashboard_mark_indeterminate', 
'resultDate,id,userId', 
'update covid19_lab_test_detail
set lab_result = ''INDETERMINATE'',
is_indeterminate = true,
indeterminate_marked_date =  #resultDate#,
indeterminate_marked_by = #userId#,
lab_collection_status = ''INDETERMINATE'',
indeterminate_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_retrieve_result_confirmed_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b9d9ff01-25f8-46e0-a9bc-da3901609368', 80240,  current_date , 80240,  current_date , 'covid19_lab_test_retrieve_result_confirmed_list', 
'searchText,limit_offset,offset,limit,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.indeterminate_marked_date as indeterminate_date,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_result as lab_result,
    ltd.result_remarks as result_remarks,
    ltd.is_recollect as is_recollect,
    ltd.other_result_remarks_selected as other_result_remarks_selected,
    ltd.lab_result_entry_on as lab_result_entry_on,
    suggested_hospital.name_in_english as suggested_hospital,
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
	sample_from.name_in_english as sample_from_health_infra,
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
	left join health_infrastructure_details suggested_hospital on clt.suggested_health_infra = suggested_hospital.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96))
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status in (''POSITIVE'',''NEGATIVE'')
and lab_result not like ''%_temp''
	and  ltd.search_text ilike concat(''%'',#searchText#,''%'')
	and ltd.is_archive is not true
	order by ltd.result_server_date desc
--	#limit_offset#
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,indeterminate_date as "indeterminateDate"
,lab_test_id as "labTestId"
,lab_result as "labResult"
,result_remarks as "resultRemarks"
,is_recollect as "isRecollect"
,other_result_remarks_selected as "otherResultRemarksSelected"
,lab_result_entry_on as "labResultEntryOn"
,suggested_hospital as "suggestedHospital"
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
,cast(''CONFIRMATION'' as text) as "resultStage"
from idsp_screening', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_edit_lab_result';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'da31b1a0-c013-4612-9d17-32da83a96905', 80240,  current_date , 80240,  current_date , 'covid19_edit_lab_result', 
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
set lab_result_entry_on = #resultDate# ,
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

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_sample_received_status';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1b605f3c-ea8e-4722-93e6-13e01fdf1e7f', 80240,  current_date , 80240,  current_date , 'lab_test_dashboard_mark_sample_received_status', 
'receiveDate,rejectionRemarks,labTestNumber,rejectionRemarkSelected,id,userId,status', 
'update covid19_lab_test_detail
set lab_collection_status = #status#,
lab_sample_rejected_by = case when #status# = ''SAMPLE_REJECTED'' then #userId# else null end,
lab_sample_rejected_on = case when #status# = ''SAMPLE_REJECTED'' then cast(#receiveDate# as timestamp) else null end,
lab_sample_reject_reason = #rejectionRemarks#,
lab_sample_received_by = case when #status# = ''SAMPLE_ACCEPTED'' then #userId# else null end,
lab_sample_received_on = case when #status# = ''SAMPLE_ACCEPTED'' then cast(#receiveDate# as timestamp) else null end,
lab_test_number = case when #status# = ''SAMPLE_ACCEPTED'' then #labTestNumber# else null end,
rejection_remark_selected = (case when #rejectionRemarkSelected# = ''null'' then null else #rejectionRemarkSelected# end),
receive_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_insert_transfer_history';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'98b90f9a-a4ae-489f-8e1f-a41462b15a8c', 80240,  current_date , 80240,  current_date , 'lab_test_insert_transfer_history', 
'healthInfraTo,labTestId,transferDate,healthInfraFrom,userId', 
'insert into covid19_lab_test_transfer_history
(lab_test_id,health_infra_from,health_infra_to,transferred_on,transfer_server_date,transferred_by)
values(#labTestId#,#healthInfraFrom#,#healthInfraTo#,cast(#transferDate# as timestamp),now(),#userId#);', 
null, 
false, 'ACTIVE');