DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_only_lab_test_admission';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid_19_get_opd_only_lab_test_admission', 
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
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.admission_from in (''OPD_ADMIT'')
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