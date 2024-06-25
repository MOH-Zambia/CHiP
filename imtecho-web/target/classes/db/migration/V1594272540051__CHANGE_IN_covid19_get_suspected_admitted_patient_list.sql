DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_suspected_admitted_patient_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2ba6a8ab-48aa-46f3-b439-6d1a27f454a7', 75398,  current_date , 75398,  current_date , 'covid19_get_suspected_admitted_patient_list', 
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
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.status in (''SUSPECT'')
	and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cacd.service_date
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
,case_no as "caseNo"
from idsp_screening;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_pending_admission_for_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0ae6165b-373c-4c3e-bf71-c6d283b612ac', 75398,  current_date , 75398,  current_date , 'covid19_get_pending_admission_for_lab_test', 
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
	clt.first_name,
	clt.middle_name,
	clt.last_name,
	clt.age,
	clt.age_month,
	clt.address,
	clt.gender,
	concat(case when clt.member_id is null 
		then clt.age
		else EXTRACT(YEAR FROM age(imt_member.dob)) end,'' Year'') as dob,
	to_char(clt.admission_date,''DD/MM/YYYY'') as admission_date,
	clt.contact_number,
	hiwd.ward_name,
	clt.current_ward_id as ward_id,
	clt.current_bed_no,
	clt.unit_no,
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
concat(case when clt.is_fever 
		then ''Fever, '' else '''' end,
                 case when clt.is_cough 
		then ''Cough, '' else '''' end,
 case when clt.is_breathlessness 
		then ''Shortness of Breath, '' else '''' end,
 case when clt.is_sari 
		then ''SARI'' else '''' end
		) as symptoms,
        clt.case_no,
	clt.emergency_contact_name,
	clt.emergency_contact_no,
	clt.pregnancy_status,
	clt.date_of_onset_symptom,
	clt.occupation,
	clt.opd_case_no,
	clt.is_migrant,
	clt.indications,
	clt.indication_other,
	concat(clt.travel_history,clt.travelled_place) as travel,
(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'')'') end) as reffer_by
	from covid19_admission_detail clt
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
        left join um_user ref_by on ref_by.id = clt.admission_entry_by
	where
	clt.suggested_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.admission_from = ''OPD_ADMIT''
	and cltd.lab_collection_status = ''POSITIVE''
	and clt.health_infra_id is null
	and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cacd.service_date
	limit #limit# offset #offset#
)
select 
id as "id"
,''opdAdmit'' as "type" 
,member_id as "memberId"
,loc_id as "districtLocationId"
,get_location_hierarchy_from_ditrict(loc_id) as "location"
,member_det as "memberDetails"
,first_name as "firstname"
,middle_name as "middlename"
,last_name as "lastname"
,dob as "dob"
,age as "age"
,age_month as "ageMonth"
,admission_date as "admissionDate"
,contact_number as "contact_no"
,address as "address"
,gender as "gender"
,ward_name as "wardName"
,ward_id as "wardId"
,current_bed_no as "bedNumber"
,unit_no as "unitNo"
,test_result as "testResult"
,health_status as "healthStatus"
,to_char(last_check_up_time,''DD/MM/YYYY'') as "lastCheckUpTime"
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
,emergency_contact_name as "emergencyContactName"
,emergency_contact_no as "emergencyContactNo"
,pregnancy_status as "pregnancyStatus"
,date_of_onset_symptom as "date_of_onset_symptom"
,occupation as "occupation"
,opd_case_no as "opdCaseNo"
,is_migrant as "isMigrant"
,indications as "indications"
,indication_other as "indicationOther"
,travel as "hasTravelHistory",
reffer_by as "refferBy",
null as "labTestStatus",
symptoms 
from idsp_screening



UNION ALL



(with idsp_screening as (
	select
	clt.id as "id",
        idsp.location_id as loc_id,
	m.family_id,
	m.id as member_id,
	m.gender,
	m.first_name,
	m.middle_name,
	m.last_name,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
EXTRACT(YEAR FROM age(m.dob)) as age,
	(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'')'') end) as reffer_by,
	(case when idsp.is_cough = 1 then true else false end) as is_cough,
	(case when idsp.is_any_illness_or_discomfort = 1 then true else false end) as is_any_illness_or_discomfort,
	(case when idsp.is_breathlessness = 1 then true else false end) as breathlessness,
	(case when idsp.is_fever = 1 then true else false end) as is_fever,
concat(case when  idsp.is_fever = 1 
		then ''Fever, '' else '''' end,
                 case when  idsp.is_cough = 1 
		then ''Cough, '' else '''' end,
 case when idsp.is_breathlessness = 1
		then ''Shortness of Breath '' else '''' end
		) as symptoms,
	(case when idsp.has_travel = 1 then ''Local'' 
		when idsp.has_travel=2 then concat(''International'',(case when idsp.country is not null then concat('' ('',idsp.country,'')'') end))
		else ''No'' end) as travel,
	concat_ws('','', address1, address2) as address,
	m.mobile_number as contact_person,
	clt.lab_test_status
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	left join um_user ref_by on ref_by.id = clt.refer_health_infra_entry_by
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.refer_health_infra_id is not null
	and clt.admission_id is null
	--and cld.refer_health_infra_id in (select id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	order by idsp.member_id
	limit #limit# offset #offset#
),contact_person as (
	select distinct on(a.member_id) a.member_id as id,
	 concat( contact_person.first_name, '' '', contact_person.middle_name, '' '', contact_person.last_name,
		'' ('', case when contact_person.mobile_number is null then ''N/A'' else contact_person.mobile_number end, '')'' ) as contactPersonMobileNo
	from imt_member contact_person
	inner join idsp_screening a on a.family_id = contact_person.family_id
	where contact_person.basic_state in (''NEW'',''IDSP'',''VERIFIED'') and contact_person.id != a.member_id and a.contact_person is null
	order by a.member_id,contact_person.dob
),
loc as (
	select distinct loc_id from idsp_screening
),
loc_det as (
	select loc.loc_id, get_location_hierarchy_from_ditrict(loc.loc_id) as aoi
	from loc
)
select 
idsp_screening.id as "id",
''refer'' as "type",
idsp_screening.member_id as "memberId",
idsp_screening.loc_id as "districtLocationId",
get_location_hierarchy_from_ditrict(idsp_screening.loc_id) as "location",
idsp_screening.member_det as "memberDetails",
idsp_screening.first_name as "firstname",
idsp_screening.middle_name as "middlename",
idsp_screening.last_name as "lastname",
idsp_screening.dob as "dob"
,idsp_screening.age  as "age"
,null as "ageMonth"
,null as "admissionDate"
,(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contact_no",
idsp_screening.address as "address",
idsp_screening.gender
,null as "wardName"
,null as "wardId"
,null as "bedNumber"
,null as "unitNo"
,null as "testResult"
,null as "healthStatus"
,null as "lastCheckUpTime"
,null as "isLabTestInProgress"
,null as "isHIV"
,null as "isHeartPatient"
,null as "isDiabetes"
,null as "isCOPD"
,null as "isRenalCondition"
,null as "isHypertension"
,null as "isImmunocompromized"
,null as "isMalignancy"
,null as "isOtherCoMobidity"
,null as "otherCoMobidity"
,idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness"
,null as "isSari"
,null as "caseNo"
,null as "emergencyContactName"
,null as "emergencyContactNo"
,null as "pregnancyStatus"
,null as "date_of_onset_symptom"
,null as "occupation"
,null as "opdCaseNo"
,null as "isMigrant"
,null as "indications"
,null as "indicationOther"
,idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy",
idsp_screening.lab_test_status as "labTestStatus",
idsp_screening.symptoms as "symptoms"
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id
)', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_confirmed_admitted_patient_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8e03a63b-cd4f-48cf-8cca-c81b9331a964', 75398,  current_date , 75398,  current_date , 'covid19_get_confirmed_admitted_patient_list', 
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
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.status in (''CONFORMED'')
        and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cacd.service_date
	limit #limit# offset #offset#
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_refer_in_patient_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'aa9a0f04-eeab-4c8c-b4b5-39dd03fed36a', 75398,  current_date , 75398,  current_date , 'covid19_get_refer_in_patient_list', 
'searchText,offset,limit,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
card.id as ref_id,
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
	clt.travel_history,
	clt.travelled_place,
	clt.is_abroad_in_contact,
	clt.abroad_contact_details,
	clt.in_contact_with_covid19_paitent,
	clt.flight_no
	from covid19_admission_detail clt
	inner join covid19_admission_refer_detail card on clt.id = card.admission_id and card.state = ''PENDING''
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	card.refer_to_health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.status in (''REFER'')
        and (#searchText# = ''null'' OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by cacd.service_date
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
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
,ref_id as "refId"
,travel_history as "travelHistory"
,travelled_place as "travelledPlace"
,is_abroad_in_contact as "is_abroad_in_contact"
,abroad_contact_details as "abroad_contact_details"
,in_contact_with_covid19_paitent as "inContactWithCovid19Paitent"
,flight_no as "flightno"
from idsp_screening;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_refer_out_patient_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c75e8cd4-9653-4ec0-a17e-bae892d145aa', 75398,  current_date , 75398,  current_date , 'covid19_get_refer_out_patient_list', 
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
        refer_detail.status as refer_status
	from covid19_admission_detail clt
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	inner join covid19_admission_refer_detail refer_detail on refer_detail.admission_id = clt.id
	where
	refer_detail.refer_from_health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	order by refer_detail.created_on desc
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
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
,refer_status as "referStatus"
from idsp_screening;', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid_19_get_opd_only_lab_test_admission';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ce8adad7-1fc7-4432-8b16-65437d7d4e97', 75398,  current_date , 75398,  current_date , 'covid_19_get_opd_only_lab_test_admission', 
'offset,limit,loggedInUserId', 
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_retrieve_admission_details_for_print';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'504567fa-8527-4276-9702-7748e52c1723', 75398,  current_date , 75398,  current_date , 'covid19_retrieve_admission_details_for_print', 
'admissionId', 
'select get_location_hierarchy_from_ditrict(clt.location_id) as "location",
clt.address as "address",
clt.pincode as "pincode",
clt.occupation as "occupation",
clt.travel_history as "travelHistory",
clt.is_abroad_in_contact as "abroadContact",
clt.in_contact_with_covid19_paitent as "covidPositiveContact",
clt.case_no as "caseNumber",
clt.opd_case_no as "opdCaseNumber",
clt.contact_number as "contactNumber",
clt.gender as "gender",
clt.is_fever as "fever",
clt.is_cough as "cough",
clt.is_breathlessness as "breathlessness",
clt.is_sari as "sari",
clt.is_hiv as "hiv",
clt.is_heart_patient as "heartPatient",
clt.is_diabetes as "diabetes",
clt.is_copd as "copd",
clt.is_hypertension as "hypertension",
clt.is_renal_condition as "renalCondition",
clt.is_immunocompromized as "immunocompromized",
clt.is_malignancy as "maligancy",
to_char(clt.date_of_onset_symptom,''DD/MM/YYYY'') as "onsetDate",
to_char(clt.discharge_date,''DD/MM/YYYY'') as "dischargeDate",
to_char(current_timestamp,''DD/MM/YYYY'') as "currentDate",
to_char(clt.admission_date,''DD/MM/YYYY'') as "admissionDate",
CASE WHEN clt.discharge_date IS NULL THEN DATE_PART(''day'',current_timestamp - clt.admission_date) 
ELSE DATE_PART(''day'',clt.discharge_date - clt.admission_date) END as "days",
clt.unit_no as "unitNumber",
hiwd.ward_name as "wardName",
clt.current_bed_no as "bedNumber",
clt.status as "status",
concat(clt.emergency_contact_name,'' ('',clt.emergency_contact_no,'')'') as "emergencyDetails",
case when clt.member_id is null 
		then concat_ws('' '',clt.first_name,clt.middle_name,clt.last_name)
		else concat(concat_ws('' '',imt_member.first_name,imt_member.middle_name,imt_member.last_name)
			, '' ('' , imt_member.unique_health_id , '')'' , '' '' , imt_member.family_id) end as "name",
clt.age as "age",
hid.name_in_english as "hospital_name"
from covid19_admission_detail clt
left join imt_member on clt.member_id = imt_member.id
left join imt_family on imt_member.family_id = imt_family.family_id
left join health_infrastructure_details hid on clt.health_infra_id = hid.id 
left join health_infrastructure_ward_details hiwd on clt.current_ward_id = hiwd.id
where clt.id = #admissionId#', 
null, 
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_admitted_patient_daily_status_print';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b36dc726-0ecf-47b5-8eb0-0d3899e5294a', 75398,  current_date , 75398,  current_date , 'covid19_get_admitted_patient_daily_status_print', 
'admissionId', 
'with temp as (
select
	cacd.id as "id",
	to_char(cacd.service_date,''DD/MM/YYYY'') as service_date,
	cacd.on_ventilator as on_ventilator,
	cacd.ventilator_type1 as ventilator_type1,
	cacd.ventilator_type2 as ventilator_type2,
	cacd.on_o2 as on_o2,
	cacd.on_air as on_air,
	cacd.remarks as remarks,
	cacd.clinically_clear as clinically_clear,
	cacd.temperature as temperature,
	cacd.pulse_rate as pulse_rate,
	cacd.bp_systolic as bp_systolic,
	cacd.bp_dialostic as bp_dialostic,
	cacd.respiration_rate as respiration_rate,
	cacd.spo2 as spo2,
	cacd.azithromycin as azithromycin,
	cacd.hydroxychloroquine as hydroxychloroquine,
	cacd.oseltamivir as oseltamivir,
	cacd.antibiotics as antibiotics,
	cacd.health_status as health_status,
	cacd.is_xray as is_xray,
	cacd.xray_detail as xray_detail,
	cacd.is_ctscan as is_ctscan,
	cacd.ct_scan_detail as ct_scan_detail,
	cacd.is_ecg as is_ecg,
	cacd.ecg_detail as ecg_detail,
	cacd.is_serum_creatinine as is_serum_creatinine,
	cacd.serum_creatinine_detail as serum_creatinine_detail,
	cacd.is_sgpt as is_sgpt,
	cacd.sgpt_detail as sgpt_detail,
	cacd.is_h1n1_test as is_h1n1_test,
	cacd.h1n1_test_detail as h1n1_test_detail,
	cacd.blood_culture as blood_culture,
	cacd.blood_culture_detail as blood_culture_detail,
	cacd.is_g6pd as is_g6pd,
	cacd.g6pd_detail as g6pd_detail
	from covid19_admitted_case_daily_status cacd
	inner join covid19_admission_detail clt on clt.id = cacd.admission_id
	where
	cacd.admission_id =   #admissionId#
	order by cacd.service_date
)
select 
id as "id" 
,service_date as "service_date"
,health_status as "health_status"
,on_ventilator as "on_ventilator"
,ventilator_type1 as "ventilator_type1"
,ventilator_type2 as "ventilator_type2"
,on_o2 as "on_o2"
,on_air as "on_air"
,remarks
,"temperature"
,"pulse_rate"
,"bp_systolic"
,"bp_dialostic"
,"respiration_rate"
,"spo2"
,"azithromycin"
,"hydroxychloroquine"
,"oseltamivir"
,"antibiotics"
, is_xray as "is_xray"
, xray_detail as "xray_detail"
, is_ctscan as "is_ctscan"
, ct_scan_detail as "ct_scan_detail"
, is_ecg as "is_ecg"
, ecg_detail as "ecg_detail"
, is_serum_creatinine as "is_serum_creatinine"
, serum_creatinine_detail as "serum_creatinine_detail"
, is_sgpt as "is_sgpt"
, sgpt_detail as "sgpt_detail"
, is_h1n1_test as "is_h1n1_test"
, h1n1_test_detail as "h1n1_test_detail"
, blood_culture as "blood_culture"
, blood_culture_detail as "blood_culture_detail"
, is_g6pd as "is_g6pd"
, g6pd_detail as "g6pd_detail"
from temp;', 
'this query is used to print the daily status of  patient', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_lab_test_for_admission_print';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'297c5400-0be1-401b-8637-5f4c5fba47ec', 75398,  current_date , 75398,  current_date , 'covid19_get_lab_test_for_admission_print', 
'admissionId', 
'select
ltd.id as "id",
ltd.lab_collection_status as "lab_collection_status",
to_char(ltd.lab_collection_on,''DD/MM/YYYY hh:mi AM'') as "lab_collection_on",
to_char(ltd.lab_sample_received_on,''DD/MM/YYYY hh:mi AM'') as "lab_sample_received_on",
to_char(ltd.lab_result_entry_on,''DD/MM/YYYY hh:mi AM'') as "lab_result_entry_on",
to_char(ltd.lab_sample_rejected_on,''DD/MM/YYYY hh:mi AM'') as "lab_sample_rejected_on",
ltd.lab_result as "lab_result",
hid1.name_in_english as "sample_health_infra",
hid2.name_in_english as "sample_health_infra_send_to",
ltd.lab_sample_reject_reason as "lab_sample_reject_reason",
ltd.lab_test_number as "lab_test_number",
ltd.lab_test_id as "lab_test_id"
from covid19_lab_test_detail ltd
left join health_infrastructure_details hid1 on ltd.sample_health_infra = hid1.id
left join health_infrastructure_details hid2 on ltd.sample_health_infra_send_to = hid2.id
where ltd.covid_admission_detail_id  =  #admissionId#', 
'this query is used for printing the admission details', 
true, 'ACTIVE');