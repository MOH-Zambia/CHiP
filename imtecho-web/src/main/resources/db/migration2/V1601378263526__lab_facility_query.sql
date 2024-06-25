DELETE FROM QUERY_MASTER WHERE CODE='retrieve_covid_lab_test_with_out_user_infra_by_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'616601f4-5fc3-4112-b87c-160fc28017e8', 74841,  current_date , 74841,  current_date , 'retrieve_covid_lab_test_with_out_user_infra_by_location', 
'user_id,locationId', 
'select *
from health_infrastructure_details
where (case when #locationId# is not null then location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) else true end)
and (case when #user_id# is not null then id not in (SELECT health_infrastrucutre_id FROM user_health_infrastructure where user_id  = #user_id#) else true end)
and is_covid_lab', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_pending_sample_receive';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2a9daba6-a0fd-472f-8560-a42278b01ffa', 74841,  current_date , 74841,  current_date , 'covid19_lab_test_pending_sample_receive', 
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
	and case when #collectionDate# != ''null'' and #collectionDate# != '''' then cast(ltd.lab_collection_on as date) = to_date(#collectionDate# , ''YYYY-MM-DD'') else true end
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