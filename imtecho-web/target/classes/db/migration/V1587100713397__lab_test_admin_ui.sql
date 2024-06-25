delete from user_menu_item where menu_config_id = 
(select id from menu_config where navigation_state = 'techo.manage.labTestAdmin');

delete from menu_config where navigation_state = 'techo.manage.labTestAdmin';

insert into menu_config
(group_id,active,menu_name,navigation_state,menu_type)
values
((select id from menu_group where group_name='COVID-19'),
true,'Lab Test Admin','techo.manage.labTestAdmin','manage');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_get_all_lab_tests';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_get_all_lab_tests', 
'searchText,limit_offset,healthInfra,loggedInUserId,wardId,collectionDate', 
'with idsp_screening as (
select
	clt.id as "id",
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
	or ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	)
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') 
	and (case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end)
	and (case when ''#healthInfra#'' != ''null'' and ''#healthInfra#'' != '''' then sample_from.name_in_english ilike ''%#healthInfra#%'' else true end)
	and (case when ''#collectionDate#'' != ''null'' and ''#collectionDate#'' != '''' then to_char(ltd.lab_collection_on,''DD/MM/YYYY'') ilike ''%#collectionDate#%'' else true end)
	and (case when ''#wardId#'' != ''null'' and ''#wardId#'' != '''' then hiwd.ward_name = ''#wardId#'' else true end)
	order by cacd.service_date desc
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


DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_transfer_hospital';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_transfer_hospital', 
'admissionId,healthInfaId', 
'update covid19_admission_detail
set health_infra_id = #healthInfaId#
where id=#admissionId#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='covid19_admin_delete_lab_test';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_admin_delete_lab_test', 
'admissionId', 
'delete from covid19_admission_detail where id  = #admissionId#;

delete from covid19_lab_test_detail where covid_admission_detail_id  = #admissionId#;

delete from covid19_admitted_case_daily_status where admission_id  = #admissionId#;

delete from covid19_admission_refer_detail where admission_id  = #admissionId#;', 
null, 
false, 'ACTIVE');