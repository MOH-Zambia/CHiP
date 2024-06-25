DELETE FROM QUERY_MASTER WHERE CODE='cm_dashboard_opd_ipd_report';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'83574a2f-4e25-47de-a87e-9a24abe33aa6', 74841,  current_date , 74841,  current_date , 'cm_dashboard_opd_ipd_report', 
'performanceDate', 
'---------cm_dashboard_opd_ipd_report---------
 with healthinfradet as (
select
	health_infrastructure_details.id,
	listvalue.value,
	health_infrastructure_details.location_id as locid,
	health_infrastructure_details.name,
	l1.english_name as district,
	l1.location_code as dcode,
	l2.english_name as taluka,
	l2.location_code as tcode
from
	health_infrastructure_details
inner join listvalue_field_value_detail listvalue on
	health_infrastructure_details.type = listvalue.id
	and listvalue.value in (''PHC'',
	''UPHC'',
	''Community Health Center''
	,''Urban Community Health Center''
	,''District Hospital''
	,''Sub District Hospital''
	,''Medical College Hospital'')
    and health_infrastructure_details.is_no_reporting_unit is not true
left join location_hierchy_closer_det dis on
	health_infrastructure_details.location_id = dis.child_id
	and dis.parent_loc_type in (''D'',
	''C'')
left join location_master l1 on
	dis.parent_id = l1.id
left join location_hierchy_closer_det tal on
	health_infrastructure_details.location_id = tal.child_id
	and tal.parent_loc_type in (''B'',
	''Z'')
left join location_master l2 on
	tal.parent_id = l2.id 
where l1.name not ilike ''%delete%''
and (l2.name is null or l2.name not ilike ''%delete%'')),
fpdetails as (
select
	fpm.health_infrastrucutre_id as hid,
	fpm.no_of_opd_attended,
	fpm.no_of_ipd_attended,
	fpm.no_of_deliveres_conducted,
	fpm.no_of_csection_conducted,
	fpm.no_of_major_operation_conducted,
	fpm.no_of_minor_operation_conducted,
	fpm.no_of_laboratory_test_conducted,
	fpm.performance_date
from
	facility_performance_master fpm
where
	performance_date = cast(''#performanceDate#'' as date) ) select
	healthinfradet.dcode as "Dist_cd",
	healthinfradet.district as "Dist_Name",
	healthinfradet.tcode as "Tcode",
	coalesce(healthinfradet.taluka, ''N/A'') as "Tal_Name",
	healthinfradet.name as "Facility_Name",
	case
		when healthinfradet.value = ''PHC'' then 1
		when healthinfradet.value = ''UPHC'' then 3
		when healthinfradet.value in (''Community Health Center'',''Urban Community Health Center'') then 4
		when healthinfradet.value in (''Sub District Hospital'') then 5
		when healthinfradet.value in (''District Hospital'',''Medical College Hospital'') then 6
	end as "Facility_Type",
	coalesce(fpdetails.no_of_opd_attended, 0) as "No_Of_OPDs",
	coalesce(fpdetails.no_of_ipd_attended, 0) as "No_of_IPDs",
	coalesce(fpdetails.no_of_deliveres_conducted, 0) as "No_of_deliveries_conducted_at_facility",
	coalesce(fpdetails.no_of_csection_conducted, 0) as "No_of_c_section_conducted_at_facility",
	coalesce(fpdetails.no_of_major_operation_conducted, 0) as "No_of_Major_operations_conducted_at_facility",
	coalesce(fpdetails.no_of_minor_operation_conducted, 0) as "No_of_Minor_operations_conducted_at_facility",
	coalesce(fpdetails.no_of_laboratory_test_conducted, 0) as "No_of_laboratory_tests_conducted_at_facility",
	case when fpdetails.performance_date is not null then to_char(fpdetails.performance_date, ''MM/dd/yyyy'') 
else to_char( cast(''#performanceDate#'' as date), ''MM/dd/yyyy'') 
 end as "Date"
from
	healthinfradet
left join fpdetails on
	healthinfradet.id = fpdetails.hid', 
'To get CM dashboard OPD IPD report', 
true, 'ACTIVE');