-- Added fields admission_from, status, suggested_health_infra, trasfer_hospital_name

DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_get_all_lab_tests';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_get_all_lab_tests', 
'searchText,limit_offset,healthInfra,wardId,collectionDate', 
'with idsp_screening as (
select
	distinct on (clt.id)clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_result as lab_result,
	ltd.lab_collection_status as lab_collection_status,
        ltd.lab_result_entry_on as lab_result_entry_on,
	ltd.lab_collection_on as lab_collection_on,
	ltd.lab_test_number as lab_test_number,
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
	sample_from."name_in_english" as sample_from_health_infra,
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
        clt.admission_from,
        clt.status,
        (select name_in_english from health_infrastructure_details where id = suggested_health_infra) as suggested_health_infra,
	(select name_in_english from health_infrastructure_details where id = referDetail.refer_to_health_infra_id) as trasfer_hospital_name,
	cacd.health_status as health_status,
	cacd.service_date as last_check_up_time
	from covid19_lab_test_detail ltd
	inner join covid19_admission_detail clt on ltd.covid_admission_detail_id = clt.id
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	left join covid19_admission_refer_detail referDetail on referDetail.admission_id =  clt.id
	where
	(case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end)
	and (case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end)
	and (case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_collection_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when ''#wardId#'' != ''null'' and ''#wardId#'' != '''' then hiwd.ward_name = ''#wardId#'' else true end)
	order by  clt.id,ltd.id
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_id as "labTestId"
,lab_result as "labResult"
,lab_collection_status as "labCollectionStatus"
,to_char(lab_result_entry_on,''DD/MM/YYYY'') as "labResultEntryOn"
,to_char(lab_collection_on,''DD/MM/YYYY'') as "labCollectionOn"
,lab_test_number as "labTestNumber"
,member_id as "memberId"
,loc_id as "locationId"
,member_det as "memberDetail"
,age as "age"
,admission_date as "admissionDate"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,admission_from as "admissionFrom"
,status as "admissionStatus"
,suggested_health_infra as "suggestedHealthInfraName"
,trasfer_hospital_name as "trasferHospitalName"
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


--covid19_admin_revert_outcome
DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_revert_outcome';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_revert_outcome', 
'admissionId', 
'with initial_lab_status as(
select DISTINCT on(cltd.covid_admission_detail_id)cltd.covid_admission_detail_id as admission_id,lab_collection_status as initial_result
from covid19_lab_test_detail cltd 
where cltd.covid_admission_detail_id = #admissionId#
order by cltd.covid_admission_detail_id,cltd.id
)
update covid19_admission_detail
set status = (case when ils.initial_result = ''POSITIVE'' then ''CONFORMED''
else ''SUSPECT'' end),
discharge_date = null,
discharge_remark = null,
discharge_status = null,
discharge_entry_by = null,
discharge_entry_on = null
from initial_lab_status ils
where id = #admissionId# and status in (''DEATH'',''DISCHARGE'', ''REFER'', ''DAMA/LAMA'');

delete from covid19_admission_refer_detail where id  in (select id from covid19_admission_refer_detail where  admission_id = #admissionId#
order by created_on desc limit 1);', 
null, 
false, 'ACTIVE');

--initialResult Field Added

DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_confirmed_admitted_patient_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid19_get_confirmed_admitted_patient_list', 
'searchText,limit_offset,loggedInUserId', 
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
        clt.case_no
	from covid19_admission_detail clt
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status in (''CONFORMED'')
        and (''#searchText#'' = ''null'' OR clt.search_text ilike ''%#searchText#%'')
	order by cacd.service_date
	#limit_offset#
)
,intial_lab_test as(
select DISTINCT on(cltd.covid_admission_detail_id)cltd.covid_admission_detail_id as admission_id,lab_collection_status as initial_result
from idsp_screening isr
left join covid19_lab_test_detail cltd on cltd.covid_admission_detail_id = isr.id
order by cltd.covid_admission_detail_id,cltd.id
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
,intial_lab_test.initial_result as "initialResult"
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
,case_no as "caseNo"
from idsp_screening
inner join intial_lab_test on idsp_screening.id = intial_lab_test.admission_id;', 
null, 
true, 'ACTIVE');