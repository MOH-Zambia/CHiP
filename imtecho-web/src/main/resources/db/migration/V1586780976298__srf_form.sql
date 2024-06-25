DELETE FROM QUERY_MASTER WHERE CODE='COVID_19_ICMR_Specimen_Referral_Form';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'COVID_19_ICMR_Specimen_Referral_Form',
'labTestIds',
'select
concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name) as "patientName",
case
    when clt.age is null then null
    else concat_ws('' '', clt.age, ''years'', case when clt.age_month is null then 0 else clt.age_month end, ''month'')
end as "age",
clt.gender as "gender",
cast(''N/A'' as text) as "villageLocation",
clt.contact_number as "mobileNumber",
cast(''Self''as text) as "mobileNumberBelongsTo",
get_location_hierarchy_from_ditrict(clt.location_id) as "disctrictLocation",
cast(''Gujarat'' as text) as "state",
cast(''Indian'' as text) as "Nationality",
cast(null as boolean) as "isBALETA",
cast(null as boolean) as "isTSNPSNS",
cast(null as boolean) as "isBloodInEDTA",
cast(null as boolean) as "isAcuteSera",
cast(null as boolean) as "isCovalescentSera",
cast(null as boolean) as "isOtherSpecimenType",
to_char(cltd.lab_collection_on, ''DD/MM/YY'')  as "collectionDate",
cast(''N/A'' as text) as "label",
cast(null as boolean) as "isRepeatedSample",
(select name_in_english from health_infrastructure_details where id = cltd.sample_health_infra)  as "sampleCollectionFacilityName",
cast(''N/A'' as text) as "collectionFacilityPincode",
case when clt.indications =''Symtomatic Person with International Travel History (last 14 days)'' then true else false end as "isSymptomaticInternational",
case when clt.indications =''Symtomatic Contacts of Laboratory Confirmed Positive Cases'' then true else false end as "isSymptomaticContact",
case when clt.indications =''Symtomatic Health Care Workers'' then true else false end as "isSymptomaticHealthcare",
case when clt.indications =''Hospitalized SARI Patient'' then true else false end as "isHospitalizedSARI",
case when clt.indications =''Asymtomatic Direct / High Risk Contact of Postivie Contact (>5 and < 14 days)'' then true else false end as "isAsymptomaticDirect",
case when clt.indications =''Healthcare worker examined Positive Case without PPE'' then true else false end as "isAsymptomaticHealthcare",
clt.address as "presentPatientAddress",
clt.pincode as "pinCode",
to_char(clt.dob, ''DD/MM/YY'') as "dateOfBirth",
cast(''N/A'' as text) as  "patientPassportNo",
cast(''N/A'' as text) as  "emailId",
cast(''N/A'' as text) as  "aadharNo",
case when clt.travel_history = ''international'' then true else false end as "travelToForeignCountry",
cast(case when clt.travel_history = ''international'' then clt.travelled_place else '''' end as text) as "travelledPlace",
cast(''N/A'' as text) as  "stayTravelDuration",
case when clt.in_contact_with_covid19_paitent = ''yes'' then true else false end as "inContactWithCovid19Paitent",
cast(case when clt.in_contact_with_covid19_paitent = ''yes'' then clt.abroad_contact_details else '''' end as text) as "confirmedPatient",
cast(''N/A'' as text) as  "isQuarantined",
cast(''N/A'' as text) as  "quarantinedPlace",
cast(''No'' as text) as  "isHealthWorker",
to_char(clt.date_of_onset_symptom, ''DD/MM/YY'') as "dateOfOnsetSymptom",
cast(''N/A'' as text) as  "firstSymptom",
clt.is_cough as "isCough",
cast(null as boolean) as "isDiarrhoea",
cast(null as boolean) as "isVomiting",
cast(null as boolean) as "isFeverAtEvaluation",
clt.is_breathlessness as "isBreathlessness",
cast(null as boolean) as "isNausea",
cast(null as boolean) as "isHaemoptysis",
cast(null as boolean) as "isBodyAche",
cast(null as boolean) as "isSoreThroat",
cast(null as boolean) as "isChestPain",
cast(null as boolean) as "isNasalDischarge",
cast(null as boolean) as "isSputum",
cast(null as boolean) as "isAbdominalPain",
cast(case when clt.is_sari then ''Yes'' else ''No'' end as text) as "isSARI",
cast(null as boolean) as "isARI",
clt.is_copd as "isCopd",
cast(null as boolean) as "isBronchitis",
clt.is_diabetes as "isDiabetes",
clt.is_hypertension as "isHypertension",
clt.is_renal_condition as "isRenalCondition",
clt.is_malignancy as "isMalignancy",
clt.is_heart_patient as "isHeartPatient",
cast(null as boolean) as "isAsthma",
cast(case when clt.is_immunocompromized then ''Yes'' else ''No'' end as text) as "isImmunocompromized",
clt.other_co_mobidity as "otherUnderlyingConditions",
to_char(clt.admission_date, ''DD/MM/YY'') as "hospitalizationDate",
cast(''N/A'' as text) as "diagnosis",
cast(''N/A'' as text) as "differentialDiagnosis",
cast(''N/A'' as text) as "etiologyIdentified",
cast(''N/A'' as text) as "atypicalPresentation",
cast(''N/A'' as text) as "unusalCourse",
cast(''N/A'' as text) as "outcome",
cast(''N/A'' as text) as "outcomeDate",
cast(''N/A'' as text) as "hospitalPhoneNo",
(select name_in_english from health_infrastructure_details where id = clt.health_infra_id) as "hospitalName",
cast(''N/A'' as text) as "nameOfDoctor",
cast(''N/A'' as text) as "hospitalEmailId",
clt.discharge_status as "dischargeStatus",
to_char(clt.discharge_date, ''DD/MM/YY'') as "dischargeDate",
to_char(cltd.lab_collection_on, ''DD/MM/YY'') as "dateOfSampleRecipt",
cast(case when cltd.lab_sample_received_on is null and cltd.lab_sample_received_by is null then ''Rejected'' else ''Accepted'' end as text) as "sampleAcceptedRejected",
to_char(cltd.lab_result_entry_on, ''DD/MM/YY'') as "dateOfTesting",
cltd.lab_result as "testResult",
cast(''N/A'' as text) as "repeatedSampleRequired"

from covid19_lab_test_detail cltd
inner join covid19_admission_detail clt on cltd.covid_admission_detail_id = clt.id
where cltd.id in ( #labTestIds# )',
null,
true, 'ACTIVE');



-- Added labtest id field
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
        cltd.id as lab_test_id
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
from idsp_screening;',
null,
true, 'ACTIVE');
