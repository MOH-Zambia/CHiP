DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_dashboard_distinct_ward_name_receive';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'03d33b28-7011-4561-8976-0ff030364203', 75398,  current_date , 75398,  current_date , 'covid19_lab_test_dashboard_distinct_ward_name_receive', 
'healthInfra,loggedInUserId', 
'select id,ward_name
from health_infrastructure_ward_details
where case when #healthInfra# != null then health_infra_id = (select id from health_infrastructure_details where name_in_english = #healthInfra#)
	else health_infra_id in (select
	Distinct ltd.sample_health_infra as id
	from covid19_lab_test_detail ltd
	where
	(((select role_id from um_user where id = #loggedInUserId#) in (59,25,96))
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	) and ltd.lab_collection_status = ''SAMPLE_COLLECTED'') end
and status = ''ACTIVE''', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_collection';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f5d95f85-43be-4b91-b607-b2bd19d3036f', 75398,  current_date , 75398,  current_date , 'covid19_lab_test_pending_sample_collection', 
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_receive';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2a9daba6-a0fd-472f-8560-a42278b01ffa', 75398,  current_date , 75398,  current_date , 'covid19_lab_test_pending_sample_receive', 
'searchText,offset,healthInfra,limit,loggedInUserId,wardId,collectionDate', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_collection_on as collection_date,
	ltd.sample_health_infra_send_to as health_infra_to,
	ltd.is_transferred as is_transferred,
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
	or ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	)and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_COLLECTED''
	and case when #searchText# != ''null'' and #searchText# != '''' then ltd.search_text ilike concat(''%'',#searchText#,''%'') else true end
	and case when #healthInfra# != ''null'' and #healthInfra# != '''' then sample_from.name_in_english ilike concat(''%'',#healthInfra#,''%'') else true end
	and case when #collectionDate# != ''null'' and #collectionDate# != '''' then cast(ltd.lab_collection_on as date) = #collectionDate# else true end
    and case when #wardId# != ''null'' and #wardId# != '''' then hiwd.ward_name = #wardId# else true end
	order by ltd.collection_server_date desc
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,collection_date as "sampleCollectionDate"
,health_infra_to as "healthInfraTo"
,is_transferred as "isTransferred"
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_retrieve_indeterminate_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'deea93fe-9d6d-4b15-a6ae-4ff348fd1fd2', 75398,  current_date , 75398,  current_date , 'covid19_lab_test_retrieve_indeterminate_list', 
'searchText,offset,limit,loggedInUserId', 
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.indeterminate_marked_date as indeterminate_date,
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
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = #loggedInUserId# and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''INDETERMINATE''
	and case when #searchText# != ''null'' and #searchText# != '''' then ltd.search_text ilike concat(''%'',#searchText#,''%'') else true end
	order by ltd.indeterminate_server_date desc
	limit #limit# offset #offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,indeterminate_date as "indeterminateDate"
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_get_all_lab_tests';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dbf0a4d8-f2ab-4955-b7ca-f00844a0b3f5', 75398,  current_date , 75398,  current_date , 'covid19_admin_get_all_lab_tests', 
'searchText,offset,healthInfra,limit,wardId,collectionDate', 
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
	(select name_in_english from health_infrastructure_details where id = clt.health_infra_id) as health_infra_name,
        (select name_in_english from health_infrastructure_details where id = clt.suggested_health_infra) as suggested_health_infra,
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
	(case when #searchText# != null and #searchText# != '''' then ltd.search_text ilike concat(''%'',#searchText#,''%'') else true end)
	and (case when #healthInfra# != null and #healthInfra# != '''' then sample_from.name_in_english ilike concat(''%'',#healthInfra#,''%'') else true end)
	and (case when #collectionDate# != null and #collectionDate# != '''' then cast(ltd.lab_collection_on as date) = #collectionDate# else true end)
	and (case when #wardId# != null and #wardId# != '''' then hiwd.ward_name = #wardId# else true end)
	order by  clt.id,ltd.id
	limit #limit# offset #offset#
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
,health_infra_name as "healthInfraName"
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



DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_retrieve_referred_for_covid_lab_test';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dbfb3a58-c7e4-4ba8-bba5-bd461686abd9', 75398,  current_date , 75398,  current_date , 'emo_dashboard_retrieve_referred_for_covid_lab_test', 
'searchText,offset,limit,loggedInUserId', 
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
        and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = #loggedInUserId#))
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
ROW_NUMBER() over () + #offset# as "srNo",
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



DELETE FROM QUERY_MASTER WHERE CODE='emo_dashboard_get_reffer_paitent_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4397ca95-e379-49cc-841e-fc6a776454d6', 75398,  current_date , 75398,  current_date , 'emo_dashboard_get_reffer_paitent_list', 
'searchText,offset,limit,loggedInUserId', 
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
        and (#searchText# = null OR clt.search_text ilike concat(''%'',#searchText#,''%''))
	and clt.refer_health_infra_id is not null
	and clt.location_id in (select child_id from location_hierchy_closer_det lhc where parent_id in (select loc_id from um_user_location ul where ul.state = ''ACTIVE'' and ul.user_id = #loggedInUserId#))
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
ROW_NUMBER() over () + #offset# as "srNo",
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