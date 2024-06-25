DELETE FROM QUERY_MASTER WHERE CODE='family_id_retrieval_by_mobile_number';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'172fdcd4-b368-4e80-b90e-5651e236a238', 80276,  current_date , 80276,  current_date , 'family_id_retrieval_by_mobile_number', 
'mobileNumber', 
'select family_id from imt_member im where mobile_number = #mobileNumber# group by family_id;', 
'Get family ids which having given mobile number', 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_mobile_number_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e94655d7-01e7-40f7-b1c8-34581c3e589d', 80276,  current_date , 80276,  current_date , 'update_mobile_number_by_member_id', 
'mobileNumber,memberId', 
'update imt_member im set mobile_number = #mobileNumber# where id = #memberId#;', 
'Update phone number by member id', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_ccc_overdue_service_member_detail';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'91b45db2-86c7-4d47-bace-4474800465eb', 80276,  current_date , 80276,  current_date , 'get_ccc_overdue_service_member_detail', 
'serviceType,fhwId', 
'with service_type_info as (
	select 2 as notification_id, ''highriskanc'' as service_name
	union
	select 2 as notification_id, ''nonhighriskanc'' as service_name
	union
	select 5 as notification_id, ''wpd'' as service_name
	union
	select 4 as notification_id, ''cs'' as service_name
	
)
,fhw_loc_id as( 
	select loc_id from um_user_location
	where user_id = #fhwId# and state = ''ACTIVE'' 
)
,fhw_child_location_id_list as (
	select child_id from location_hierchy_closer_det,fhw_loc_id where parent_id in (fhw_loc_id.loc_id)
)
select 
	mem.id, mem.member_id, 
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name,'' ('',imt_member.unique_health_id,'')'') as "memberName",
	mem.last_given_service_date,get_location_hierarchy(last_given_service_location),
	mem.service_due_on_date,  
	(CAST((current_date) AS date) - CAST((mem.service_due_on_date ) AS date)) as datedifference,
	mem.location_id, mem.notification_type_id,
	imt_member.dob as member_dob,
	imt_member.immunisation_given as member_immunisation_given
	from ccc_overdue_services_follow_up_info mem
	inner join notification_type_master noti on noti.id = mem.notification_type_id
	inner join imt_member on imt_member.id = mem.member_id
	cross join fhw_child_location_id_list
	cross join service_type_info
	left join gvk_high_risk_follow_up_usr_info high_risk on high_risk.member_id = mem.member_id and mem.notification_type_id = 2
	where call_state in (''com.argusoft.imtecho.ccc.call.to-be-processed'', ''com.argusoft.imtecho.ccc.call.processing'')
			      
	and mem.call_attempt < 3
	and mem.service_state in (''PENDING'' , ''RESCHEDULE'')
	and fhw_child_location_id_list.child_id = mem.location_id
	and service_name = #serviceType#
	and  mem.notification_type_id = service_type_info.notification_id 
	and  case when service_name = ''highriskanc'' then (high_risk.id is not null)
		when service_name = ''nonhighriskanc'' then (high_risk.id is null)
		else true end', 
null, 
true, 'ACTIVE');