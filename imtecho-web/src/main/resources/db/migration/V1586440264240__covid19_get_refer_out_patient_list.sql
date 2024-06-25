DELETE FROM QUERY_MASTER WHERE CODE='covid19_get_refer_out_patient_list';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
74840,  current_date , 74840,  current_date , 'covid19_get_refer_out_patient_list', 
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
	cacd.service_date as last_check_up_time
	from covid19_admission_detail clt
	inner join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	inner join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	inner join covid19_lab_test_detail cltd on cltd.id = clt.last_lab_test_id
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	clt.health_infra_id = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.discharge_status in (''REFER'')
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
,on_ventilator
,ventilator_type1
,ventilator_type2
,on_o2
,on_air
,remarks
,"isLabTestInProgress"
from idsp_screening;', 
null, 
true, 'ACTIVE');