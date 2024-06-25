INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Command and Control Center','fhs',TRUE,'techo.dashboard.cccverification','{"canFollowUpOverdueServices":false}');

CREATE TABLE  if not exists ccc_overdue_services_follow_up_info
(
  id bigserial NOT NULL,
  member_id bigint,
  notification_type_id bigint,
  call_state varchar(255),
  schedule_date timestamp without time zone,
  call_attempt int default 0,
  location_id bigint,
  service_due_on_date timestamp without time zone,
  service_expiry_date timestamp without time zone,
  service_scedule_date timestamp without time zone,
  last_given_service_date timestamp without time zone,
  last_given_service_location bigint,
  service_state varchar(255),
  ref_code bigint,
  mo_user_id bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT ccc_overdue_services_follow_up_info_pkey PRIMARY KEY (id)
);

CREATE TABLE if not exists ccc_activity_log
(
  id bigserial NOT NULL ,
  state varchar(255),
  "timestamp" timestamp without time zone,
  user_id bigint,
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT ccc_activity_log_pkey PRIMARY KEY (id)
);


CREATE TABLE if not exists ccc_manage_call_master
(
  id bigserial NOT NULL,
  user_id bigint,
  member_id bigint,
  mobile_number varchar(12),
  call_type varchar(255),
  call_response varchar(255),
  created_on timestamp without time zone,
  created_by bigint,
  modified_on timestamp without time zone,
  modified_by bigint,
  CONSTRAINT ccc_manage_call_master_pkey PRIMARY KEY (id)
);


CREATE TABLE if not exists ccc_overdue_services_follow_up_response
(
  id bigserial NOT NULL,
  manage_call_master_id bigint,
  member_id bigint,
  call_response varchar(255),
  processing_time bigint,
 CONSTRAINT ccc_overdue_services_follow_up_response_pkey PRIMARY KEY (id)
);

delete from query_master where code = 'get_ccc_overdue_service_member_detail';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_ccc_overdue_service_member_detail','fhwId,serviceType','
with service_type_info as (
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
	mem.location_id, mem.notification_type_id
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
	and service_name = ''#serviceType#''
	and  mem.notification_type_id = service_type_info.notification_id 
	and  case when service_name = ''highriskanc'' then (high_risk.id is not null)
		when service_name = ''nonhighriskanc'' then (high_risk.id is null)
		else true end
',true,'ACTIVE');
