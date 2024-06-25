DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_admission_by_health_infra_and_case_no';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_get_admission_by_health_infra_and_case_no', 
'loggedInUserId,caseNo', 
'with health_infra_det as (
select * from health_infrastructure_details where id = (select uhi.health_infrastrucutre_id 
from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
)
select concat_ws('' '',first_name, middle_name,last_name,''is already register with same indoor case no. Please enter new indoor case number'') as "resultMsg"
from covid19_admission_detail where health_infra_id in (select id from health_infra_det) 
and case_no = ''#caseNo#'' limit 1', 
null, 
true, 'ACTIVE');

--Case No field Added
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
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
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

-- Case No Field added.
DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_suspected_admitted_patient_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_get_suspected_admitted_patient_list', 
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
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status in (''SUSPECT'')
	and (''#searchText#'' = ''null'' OR clt.search_text ilike ''%#searchText#%'')
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
,case_no as "caseNo"
from idsp_screening;', 
null, 
true, 'ACTIVE');


--Covid2019 Suspect List UI Changes

alter table covid19_lab_test_recommendation
drop column if exists source,   
add column source varchar(1024);

--Source Field Added.
DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_retrieve_referred_for_covid_lab_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
1,  current_date , 1,  current_date , 'emo_dashboard_retrieve_referred_for_covid_lab_test', 
'limit_offset,loggedInUserId', 
'with idsp_screening as (
	select
	clt.id as "id",
	clt.source as "source",
	idsp.location_id as loc_id,
	m.family_id,
	m.id as member_id,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
	(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'') ('',urm.name,'')'') end) as reffer_by,
	(case when idsp.is_cough = 1 then true else false end) as is_cough,
	(case when idsp.is_any_illness_or_discomfort = 1 then true else false end) as is_any_illness_or_discomfort,
	(case when idsp.is_breathlessness = 1 then true else false end) as breathlessness,
	(case when idsp.is_fever = 1 then true else false end) as is_fever,
	(case when idsp.has_travel = 1 then ''Local'' 
		when idsp.has_travel=2 then concat(''International'',(case when idsp.country is not null then concat('' ('',idsp.country,'')'') end))
		else ''No'' end) as travel,
	concat_ws('','', address1, address2) as address,
	m.mobile_number as contact_person
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
	left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.lab_test_status = ''PENDING''
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
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
)/*, fhw_det as (
	select loc.loc_id,
	u.first_name || '' '' || u.last_name || '' ('' || u.user_name || '')'' || ''<br>''
	|| ''Contact : '' || case when u.contact_number is not null then u.contact_number else ''N/A'' end as fhw
	from um_user_location ul, um_user u, loc,location_hierchy_closer_det
	where loc.loc_id = location_hierchy_closer_det.child_id and
	location_hierchy_closer_det.parent_id = ul.loc_id and u.id = ul.user_id
	and u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
	and u.role_id in (select id from um_role_master where name in (''MO UPHC'', ''MO PHC''))
	group by loc.loc_id, ul.state, u.state, u.first_name, u.last_name, u.user_name, u.contact_number
)*/
select 
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
idsp_screening.source as "source",
idsp_screening.member_det as "memberDetails",
loc_det.aoi as "location",
(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contactPersonMobileNo",
idsp_screening.dob as "dob",
idsp_screening.address as "address",
idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness",
idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', 
null, 
true, 'ACTIVE');


--Source Field Added.

DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_retrieve_approved_lab_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'emo_dashboard_retrieve_approved_lab_test', 
'limit_offset,loggedInUserId', 
'with idsp_screening as (
	select
	clt.id as "id",
        clt.source as "source",
	idsp.location_id as loc_id,
	m.family_id,
	m.id as member_id,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
	(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'') ('',urm.name,'')'') end) as reffer_by,
	
	(case when idsp.is_cough = 1 then true else false end) as is_cough,
	(case when idsp.is_any_illness_or_discomfort = 1 then true else false end) as is_any_illness_or_discomfort,
	(case when idsp.is_breathlessness = 1 then true else false end) as breathlessness,
	(case when idsp.is_fever = 1 then true else false end) as is_fever,
	(case when idsp.has_travel = 1 then ''Local'' 
		when idsp.has_travel=2 then concat(''International'',(case when idsp.country is not null then concat('' ('',idsp.country,'')'') end))
		else ''No'' end) as travel,
	concat_ws('','', address1, address2) as address,
	m.mobile_number as contact_person,
	clt.lab_test_status
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
       left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	where clt.lab_test_status in (''APPROVE'',''SYSTEM_APPROVE'')
	and clt.refer_health_infra_id is null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
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
)/*, fhw_det as (
	select loc.loc_id,
	u.first_name || '' '' || u.last_name || '' ('' || u.user_name || '')'' || ''<br>''
	|| ''Contact : '' || case when u.contact_number is not null then u.contact_number else ''N/A'' end as fhw
	from um_user_location ul, um_user u, loc,location_hierchy_closer_det
	where loc.loc_id = location_hierchy_closer_det.child_id and
	location_hierchy_closer_det.parent_id = ul.loc_id and u.id = ul.user_id
	and u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
	and u.role_id in (select id from um_role_master where name in (''MO UPHC'', ''MO PHC''))
	group by loc.loc_id, ul.state, u.state, u.first_name, u.last_name, u.user_name, u.contact_number
)*/
select 
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
idsp_screening.source as "source",
idsp_screening.member_det as "memberDetails",
loc_det.aoi as "location",
(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contactPersonMobileNo",
idsp_screening.dob as "dob",
idsp_screening.address as "address",
idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness",
idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy",
idsp_screening.lab_test_status as "labTestStatus"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', 
null, 
true, 'ACTIVE');

--Souce field added

DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_get_reffer_paitent_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'emo_dashboard_get_reffer_paitent_list', 
'limit_offset,loggedInUserId', 
'with idsp_screening as (
	select
	clt.id as "id",
        clt.source as "source",
	idsp.location_id as loc_id,
	m.family_id,
	m.id as member_id,
	m.first_name || '' '' || m.middle_name || '' '' || m.last_name || '' ('' || m.unique_health_id || '')'' || ''<br>'' || m.family_id as member_det,
	concat(to_char(m.dob, ''DD/MM/YYYY''),''('',EXTRACT(YEAR FROM age(m.dob)),'')'') as dob,
	(case when ref_by.id is null then ''N/A'' 
		else concat(concat_ws('' '',ref_by.first_name,ref_by.middle_name,ref_by.last_name),'' ('',ref_by.contact_number,'')'',''<BR>('',ref_by.user_name,'') ('',urm.name,'')'') end) as reffer_by,
	
	(case when idsp.is_cough = 1 then true else false end) as is_cough,
	(case when idsp.is_any_illness_or_discomfort = 1 then true else false end) as is_any_illness_or_discomfort,
	(case when idsp.is_breathlessness = 1 then true else false end) as breathlessness,
	(case when idsp.is_fever = 1 then true else false end) as is_fever,
	(case when idsp.has_travel = 1 then ''Local'' 
		when idsp.has_travel=2 then concat(''International'',(case when idsp.country is not null then concat('' ('',idsp.country,'')'') end))
		else ''No'' end) as travel,
	concat_ws('','', address1, address2) as address,
	m.mobile_number as contact_person,
	clt.lab_test_status,
	case when clt.admission_id is not null then ''Admitted'' else ''PENDING'' end  as addmision_status,
	hid.name as refer_health_infra
	from covid19_lab_test_recommendation clt
	inner join imt_member m on clt.member_id = m.id
	inner join imt_family f on f.family_id = m.family_id
	inner join health_infrastructure_details hid on hid.id = clt.refer_health_infra_id
	left join um_user ref_by on ref_by.id = clt.reffer_by
    left join um_role_master urm on urm.id = ref_by.role_id
	left join idsp_screening_analytics idsp on clt.member_id = idsp.member_id
	
	where clt.lab_test_status in (''APPROVE'',''SYSTEM_APPROVE'')
	and clt.refer_health_infra_id is not null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = ''#loggedInUserId#''))
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
)/*, fhw_det as (
	select loc.loc_id,
	u.first_name || '' '' || u.last_name || '' ('' || u.user_name || '')'' || ''<br>''
	|| ''Contact : '' || case when u.contact_number is not null then u.contact_number else ''N/A'' end as fhw
	from um_user_location ul, um_user u, loc,location_hierchy_closer_det
	where loc.loc_id = location_hierchy_closer_det.child_id and
	location_hierchy_closer_det.parent_id = ul.loc_id and u.id = ul.user_id
	and u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
	and u.role_id in (select id from um_role_master where name in (''MO UPHC'', ''MO PHC''))
	group by loc.loc_id, ul.state, u.state, u.first_name, u.last_name, u.user_name, u.contact_number
)*/
select 
ROW_NUMBER() over () + cast(SUBSTRING(''#limit_offset#'', POSITION(''offset'' in ''#limit_offset#'') + 7) as int) as "srNo",
idsp_screening.id as "id",
idsp_screening.source as "source",
idsp_screening.member_det as "memberDetails",
loc_det.aoi as "location",
(case when idsp_screening.contact_person is not null then idsp_screening.contact_person else contact_person.contactPersonMobileNo end) as "contactPersonMobileNo",
idsp_screening.dob as "dob",
idsp_screening.address as "address",
idsp_screening.is_cough as "hasCough",
idsp_screening.is_fever as "hasFever",
idsp_screening.breathlessness as "hasBreathlessness",
idsp_screening.travel as "hasTravelHistory",
idsp_screening.reffer_by as "refferBy",
idsp_screening.lab_test_status as "labTestStatus",
idsp_screening.refer_health_infra as "referHealthInfra",
idsp_screening.addmision_status as "addmissionStatus"
/*fhw_det.fhw as "moDetails"*/
from idsp_screening
left join contact_person on contact_person.id = idsp_screening.id
inner join loc_det on idsp_screening.loc_id = loc_det.loc_id;', 
null, 
true, 'ACTIVE');