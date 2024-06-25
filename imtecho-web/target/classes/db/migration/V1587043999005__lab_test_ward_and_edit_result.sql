-- For filter by ward name in lab collection tab.

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_dashboard_distinct_ward_name';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
69973,  current_date , 69973,  current_date , 'covid19_lab_test_dashboard_distinct_ward_name', 
'healthInfra,loggedInUserId', 
'select id,ward_name
from health_infrastructure_ward_details
where case when ''#healthInfra#'' != ''null'' then health_infra_id = (select id from health_infrastructure_details where name_in_english = ''#healthInfra#'')
	else health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure where user_id = ''#loggedInUserId#'' and state = ''ACTIVE'') end
and status = ''ACTIVE''', 
null, 
true, 'ACTIVE');


-- Added lab_result_entry_on, result_remarks, other_result_remarks_selected, is_recollect fields

DELETE FROM QUERY_MASTER WHERE CODE='covid19_lab_test_retrieve_result_confirmed_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'covid19_lab_test_retrieve_result_confirmed_list', 
'searchText,limit_offset,loggedInUserId', 
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
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status in (''POSITIVE'',''NEGATIVE'')
and lab_result not like ''%_temp''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	and ltd.is_archive is not true
	order by ltd.result_server_date desc
	#limit_offset#
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