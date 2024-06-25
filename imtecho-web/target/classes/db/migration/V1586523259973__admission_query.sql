DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_pending_admission_for_lab_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid19_get_pending_admission_for_lab_test', 
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
	clt.suggested_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.admission_from = ''OPD ADMIT''
	and cltd.lab_collection_status = ''POSITIVE''
	--and (''#searchText#'' = ''null'' OR clt.search_text ilike ''%#searchText#%'')
	order by cacd.service_date
	#limit_offset#
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
	--and cld.refer_health_infra_id in (select id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	order by idsp.member_id
	#limit_offset#
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

DELETE FROM QUERY_MASTER WHERE CODE='update_covid19_new_admission_detail';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'update_covid19_new_admission_detail', 
'inContactWithCovid19Paitent,otherCoMobidity,firstname,indications,occupation,gender,bed_no,date_of_onset_symptom,isHypertension,isRenalCondition,emergencyContactNo,isHeartPatient,isOtherCoMobidity,abroad_contact_details,flightno,referFromHosital,opdCaseNo,contact_no,admission_date,case_number,isImmunocompromized,address,unitno,loggedIn_user,ward_no,emergencyContactName,isSari,hasCough,pregnancy_status,middlename,travelHistory,isCOPD,travelledPlace,age_month,lastname,isMalignancy,hasShortnessBreath,isMigrant,hasFever,isHIV,otherIndications,districtLocationId,is_abroad_in_contact,admissionId,isDiabetes,age', 
'update covid19_admission_detail set
first_name =''#firstname#'',
middle_name =(case when ''#middlename#'' = ''null'' then null else ''#middlename#'' end),
last_name =(case when ''#lastname#'' = ''null'' then null else ''#lastname#'' end),
age =(case when ''#age#'' = ''null'' then  age else  #age# end)
,
age_month =(case when ''#age_month#'' = ''null'' then  age_month else  #age_month# end),
contact_number =(case when ''#contact_no#'' = ''null'' then null else ''#contact_no#'' end),
address =(case when ''#address#'' = ''null'' then null else ''#address#'' end),
gender =(case when ''#gender#'' = ''null'' then null else ''#gender#'' end),
flight_no =(case when ''#flightno#'' = ''null'' then null else ''#flightno#'' end),
refer_from_hospital =(case when ''#referFromHosital#'' = ''null'' then null else ''#referFromHosital#'' end),
case_no =(case when ''#case_number#'' = ''null'' then null else ''#case_number#'' end),
unit_no =(case when ''#unitno#'' = ''null'' then null else ''#unitno#'' end),
is_cough =#hasCough#,
is_fever =#hasFever#,
is_breathlessness =#hasShortnessBreath#,
location_id =''#districtLocationId#'',
current_ward_id =#ward_no#,
current_bed_no =''#bed_no#'',
admission_date =''#admission_date#'',
admission_entry_by =#loggedIn_user#,
admission_entry_on =now(),
is_hiv = #isHIV#,
is_heart_patient =#isHeartPatient#,
is_diabetes =#isDiabetes#,
admission_from =''NEW'',
status =''CONFORMED'',
emergency_contact_name =(case when ''#emergencyContactName#'' = ''null'' then null else ''#emergencyContactName#'' end),
emergency_contact_no =(case when ''#emergencyContactNo#'' = ''null'' then null else ''#emergencyContactNo#'' end),
is_immunocompromized =#isImmunocompromized#,
is_hypertension =#isHypertension#,
is_malignancy =#isMalignancy#,
is_renal_condition =#isRenalCondition#,
is_copd =#isCOPD#,
pregnancy_status =(case when ''#pregnancy_status#'' = ''null'' then null else ''#pregnancy_status#'' end),
date_of_onset_symptom =(case when ''#date_of_onset_symptom#'' = ''null'' then null else to_date(''#date_of_onset_symptom#'',''MM-DD-YYYY'') end),
occupation =(case when ''#occupation#'' = ''null'' then null else ''#occupation#'' end),
travel_history =(case when ''#travelHistory#'' = ''null'' then null else ''#travelHistory#'' end),
travelled_place =(case when ''#travelledPlace#'' = ''null'' then null else ''#travelledPlace#'' end),
is_abroad_in_contact =(case when ''#is_abroad_in_contact#'' = ''null'' then null else ''#is_abroad_in_contact#'' end),
abroad_contact_details =(case when ''#abroad_contact_details#'' = ''null'' then null else ''#abroad_contact_details#'' end),
in_contact_with_covid19_paitent =(case when ''#inContactWithCovid19Paitent#'' = ''null'' then null else ''#inContactWithCovid19Paitent#'' end),
opd_case_no =(case when ''#opdCaseNo#'' = ''null'' then null else ''#opdCaseNo#'' end),
is_other_co_mobidity =#isOtherCoMobidity#,
other_co_mobidity =(case when ''#otherCoMobidity#'' = ''null'' then null else ''#otherCoMobidity#'' end),
is_sari =#isSari#,
indications =(case when ''#indications#'' = ''null'' then null else ''#indications#'' end),
indication_other =(case when ''#otherIndications#'' = ''null'' then null else ''#otherIndications#'' end),
is_migrant =#isMigrant#
where id=''#admissionId#'';', 
null, 
false, 'ACTIVE');