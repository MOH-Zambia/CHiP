delete from query_master where code = 'covid19_lab_test_search_collection';
delete from query_master where code = 'covid19_lab_test_search_receive';
delete from query_master where code = 'covid19_lab_test_search_result';
delete from query_master where code = 'covid19_lab_test_search_indeterminate';

delete from QUERY_MASTER where CODE='covid19_lab_test_pending_sample_collection';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
409,  current_date , 409,  current_date , 'covid19_lab_test_pending_sample_collection',
'searchText,limit_offset,loggedInUserId',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
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
	ltd.sample_health_infra = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''COLLECTION_PENDING''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by cacd.service_date
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
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

delete from QUERY_MASTER where CODE='covid19_lab_test_pending_sample_receive';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_receive',
'searchText,limit_offset,loggedInUserId',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_collection_on as collection_date,
	ltd.sample_health_infra_send_to as health_infra_to,
	ltd.is_transferred as is_transferred,
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
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_COLLECTED''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by ltd.collection_server_date
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,collection_date as "sampleCollectionDate"
,health_infra_to as "healthInfraTo"
,is_transferred as "isTransferred"
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
from idsp_screening;',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='covid19_lab_test_pending_sample_result';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_pending_sample_result',
'searchText,limit_offset,loggedInUserId',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.lab_sample_received_on as receive_date,
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
	left join health_infrastructure_ward_details hiwd on hiwd.id = clt.current_ward_id
	left join covid19_admitted_case_daily_status cacd on cacd.id = clt.last_check_up_detail_id
	left join health_infrastructure_details sample_from on sample_from.id = ltd.sample_health_infra
	left join imt_member on clt.member_id = imt_member.id
	left join imt_family on imt_member.family_id = imt_family.family_id
	where
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''SAMPLE_ACCEPTED''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by ltd.receive_server_date
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,receive_date as "sampleReceiveDate"
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

delete from QUERY_MASTER where CODE='covid19_lab_test_retrieve_indeterminate_list';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_retrieve_indeterminate_list',
'searchText,limit_offset,loggedInUserId',
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
	ltd.sample_health_infra_send_to = (select uhi.health_infrastrucutre_id from user_health_infrastructure uhi where uhi.user_id = ''#loggedInUserId#'' and uhi.state = ''ACTIVE'')
	and clt.status not in (''DISCHARGED'',''DEAD'',''REFER'') and ltd.lab_collection_status = ''INDETERMINATE''
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by ltd.indeterminate_server_date
	#limit_offset#
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

delete from QUERY_MASTER where CODE='covid19_lab_test_retrieve_result_confirmed_list';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
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
	and case when ''#searchText#'' != ''null'' and ''#searchText#'' != '''' then ltd.search_text ilike ''%#searchText#%'' else true end
	order by ltd.result_server_date
	#limit_offset#
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,indeterminate_date as "indeterminateDate"
,lab_test_id as "labTestId"
,lab_result as "labResult"
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

delete from QUERY_MASTER where CODE='covid19_lab_test_retrieve_result_confirmed_list_all';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_retrieve_result_confirmed_list_all',
'loggedInUserId',
'with idsp_screening as (
select
	clt.id as "id",
	ltd.id as lab_id,
	ltd.lab_test_number as lab_test_number,
	ltd.indeterminate_marked_date as indeterminate_date,
	ltd.lab_test_id as lab_test_id,
	ltd.lab_result as lab_result,
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
	order by ltd.result_server_date
)
select
id as "admissionId"
,lab_id as "labCollectionId"
,lab_test_number as "labTestNumber"
,indeterminate_date as "indeterminateDate"
,lab_test_id as "labTestId"
,lab_result as "labResult"
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

delete from QUERY_MASTER where CODE='covid19_lab_test_result_report_print';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'covid19_lab_test_result_report_print',
'labTestIds',
'select admission.name_in_english as hospital_name,
admission.address as hospital_address,
to_char(now(),''DD/MM/YYYY HH24:MM'') as reporting_date,
referring.name_in_english as referring_hospital,
to_char(covid19_admission_detail.date_of_onset_symptom,''DD/MM/YYYY'') as onset_illness_date,
to_char(covid19_lab_test_detail.lab_collection_on,''DD/MM/YYYY HH24:MM'') as sample_collection_date,
to_char(covid19_lab_test_detail.lab_sample_received_on,''DD/MM/YYYY HH24:MM'') as receipt_date,
cast(''N.A'' as text) as quality_on_arrival,
covid19_lab_test_detail.lab_test_id as report_id,
covid19_lab_test_detail.lab_test_id as sample_id,
concat(covid19_admission_detail.first_name,'' '',covid19_admission_detail.middle_name,'' '',covid19_admission_detail.last_name) as patient_name,
cast(covid19_admission_detail.age as text) as age,
covid19_admission_detail.gender as sex,
cast(''N.A'' as text) as specimen_type,
to_char(covid19_lab_test_detail.lab_result_entry_on,''DD/MM/YYYY HH24:MM'') as date_of_sample_testing,
covid19_lab_test_detail.lab_result as SARS_CoV_2_result,
cast(''N.A'' as text) as other_respiratory_virus,
covid19_admission_detail.address as patient_address,
cast(''N.A'' as text) as electronically_signed_by
from covid19_lab_test_detail
inner join covid19_admission_detail on covid19_lab_test_detail.covid_admission_detail_id = covid19_admission_detail.id
left join health_infrastructure_details admission on covid19_admission_detail.health_infra_id = admission.id
left join health_infrastructure_details referring on covid19_lab_test_detail.sample_health_infra = referring.id
where covid19_lab_test_detail.id in (#labTestIds#)',
null,
true, 'ACTIVE');

create or replace function public.covid19_lab_test_detail_insert_update_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
begin
	NEW.search_text = concat_ws(' ',
		(select concat_ws(' ',
			first_name,
			middle_name,
			last_name,
			case_no,
			unit_no,
			opd_case_no,
			current_bed_no,
			contact_number
			)
			from covid19_admission_detail
			where id = NEW.covid_admission_detail_id
		),
	NEW.lab_test_number,
	NEW.lab_result,
	NEW.indeterminate_lab_name,
	(select name from health_infrastructure_details where id = NEW.sample_health_infra),
	(select name from health_infrastructure_details where id = NEW.sample_health_infra_send_to)
);
   RETURN NEW;
END;
$function$
;

update menu_config
set feature_json = '{"canSampleCollect" : false, "canSampleReceive" : false, "canSampleResult" : false,"canIndeterminate":false,"canTransfer":false,"canResultConfirm":false}'
where menu_name = 'Lab';