-- SOH User Approval

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_user_for_health_approval';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'fa8c87a4-4db6-4420-a783-63a669f64109', 75398,  current_date , 75398,  current_date , 'retrieve_user_for_health_approval', 
'state', 
'select * from soh_user where state = #state#', 
null, 
true, 'ACTIVE');


-- Place Of Service Delivery

DELETE FROM QUERY_MASTER WHERE CODE='get_service_by_location';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'16be61f5-2ce0-4516-9e97-0e3095d8bdaa', 75398,  current_date , 75398,  current_date , 'get_service_by_location', 
'fromDate,locationId,toDate', 
'with services_by_dates as (
select
parent_id,
sum(case when geo_location_state = ''CORRECT'' then 1 else 0 end) as correct,
sum(case when geo_location_state = ''INCORRECT'' then 1 else 0 end) as incorrect,
sum(case when geo_location_state = ''NOT_FOUND'' or (ser.id is not null and geo_location_state is null) then 1 else 0 end) as notfound
from location_hierchy_closer_det lh left join rch_member_services_last_90_days ser
on lh.child_id = ser.location_id
and ser.service_date between #fromDate# and #toDate#  and
service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'')
and
ser.latitude is not null and ser.latitude != ''0.0''
where
lh.parent_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id=#locationId# and depth = 1
)
group by parent_id
)
select ser.*,lm.name,lm.type from services_by_dates ser
inner join location_master lm on ser.parent_id = lm.id', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_service_by_service_date';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8e220db1-036a-4b7a-8db6-b264b0296734', 75398,  current_date , 75398,  current_date , 'get_service_by_service_date', 
'fromDate,locationId,toDate', 
'with services_by_dates as(
	select 
	sum(case when geo_location_state = ''CORRECT'' then 1 else 0 end) as correct, 
        sum(case when geo_location_state = ''INCORRECT'' then 1 else 0 end) as incorrect,
        sum(case when geo_location_state = ''NOT_FOUND'' or geo_location_state is null then 1 else 0 end) as notfound,
        to_char(ser.service_date,''yyyy-MM-dd'') as service_date_temp
	from rch_member_services_last_90_days ser, location_hierchy_closer_det lh 
	where 
	ser.service_date between  #fromDate# and #toDate#  
       and ser.latitude is not null and ser.latitude != ''0.0'' 
        and service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'') and 
	lh.child_id = ser.location_id  
	and lh.parent_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id=#locationId# and depth = 1)
	group by service_date_temp order by service_date_temp
)
select to_char(to_date(service_date_temp,''yyyy-MM-dd''),''dd-Mon(Dy)'' ) as service_date_view,*
from services_by_dates', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_service_line_list_by_location';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'70bfae44-add8-4f65-b6cc-55132ad259b1', 75398,  current_date , 75398,  current_date , 'get_service_line_list_by_location', 
'fromDate,locationId,toDate', 
'with location_services as (
select 
rlfu.*
from rch_member_services rlfu 
left join location_master latLongLocation on latLongLocation.id = rlfu.lat_long_location_id
where 
rlfu.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
and
case when ''all'' = ''all'' then rlfu.service_type in (''FHW_LMP'',''FHW_ANC'',''FHW_MOTHER_WPD'',''FHW_PNC'',''FHW_CS'') else rlfu.service_type=''all'' end 
and service_date between #fromDate# and #toDate# order by service_date desc
)
select 
to_char(ls.service_date,''dd-MM-yyyy'') as "serviceDate", 
case when ls.service_type = ''FHW_LMP'' then ''LMP Service''
     when ls.service_type = ''FHW_ANC'' then ''ANC Service''
     when ls.service_type = ''FHW_MOTHER_WPD'' then ''Delivery Service''
     when ls.service_type = ''FHW_PNC'' then ''PNC Service''
     when ls.service_type = ''FHW_CS'' then ''Child Service'' end 
 as "serviceType",
ls.lat_long_location_distance  as  "latLongLocationDistrance",
ls.latitude,
ls.longitude,
ls.geo_Location_State as "geoLocationState",
ls.location_id as "locationId",
concat(um.first_name,'' '',um.last_name) as name,
concat(im.first_name,'' '',im.last_name) as "memberName",
get_location_hierarchy(ls.location_id) as Location, 
get_location_hierarchy(ls.lat_long_location_id) as "latLongLocation"
from location_services ls
inner join um_user um  on ls.user_id = um.id
inner join imt_member im on ls.member_id = im.id
--where geo_location_state in (''CORRECT'',''INCORRECT'')', 
null, 
true, 'ACTIVE');

-- Staff SMS Config

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_staff_sms_user_sms_status_list';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2a37aae-3f77-4855-8653-1772bd802da8', 75398,  current_date , 75398,  current_date , 'retrieve_staff_sms_user_sms_status_list', 
'staffSmsConfigId', 
'with staff_sms as(
select id, config_type, jsonb_array_elements(cast(user_list as jsonb)) as elem from sms_staff_sms_master where id = #staffSmsConfigId#
)
select sc.id,sc.config_type as "configType", sm.id as "smsId", sc.elem->>''mobileNumber'' as "mobileNumber", sc.elem->>''smsQueueId'' as "smsQueueId" ,
case when sc.config_type = ''ROLE_LOCATION_BASED'' then
(select CONCAT(u.first_name, '' '', u.last_name,'' ('', u.user_name, '')'') from um_user u where id = cast(sc.elem->>''userId'' as Integer) and state = ''ACTIVE'')
end  as "userName",
case when sq.sms_id is not null and sm.carrier_status is not null then sm.carrier_status else ''N.A.''end as "smsStatus"
from staff_sms sc
left join sms_queue sq on cast(sc.elem->>''smsQueueId'' as Integer) = sq.id
left join sms sm on sm.id = sq.sms_id', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_staff_sms_by_userid';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1ec2af2c-e9db-4783-9ec7-b543287d02e9', 75398,  current_date , 75398,  current_date , 'retrieve_staff_sms_by_userid', 
'userId', 
'with staff_sms as(
select id, jsonb_array_elements(cast(user_list as jsonb))->> ''mobileNumber'' as elem from sms_staff_sms_master
)
select sm.id, sm.name, sm.sms_template as "smsTemplate", sm.trigger_type as "triggerType", sm.schedule_date_time as "dateTime", 
sm.state, sm.status,  sm.config_type as "configType",
(select CONCAT(u.first_name, '' '', u.last_name, '' ('', u.user_name, '')'')as "createdUserName" from um_user u where id = sm.created_by and state = ''ACTIVE'') ,
  sm.created_on, count(sc.elem) as "userCount"
from sms_staff_sms_master sm 
left join staff_sms sc on sc.id = sm.id 
where created_by = #userId#
group by sm.id,sm.created_on, sm.sms_template, sm.trigger_type, sm.schedule_date_time, "createdUserName", sm.config_type,
sm.state, sm.status, sm.name
order by created_on desc', 
null, 
true, 'ACTIVE');

-- Suspected CP

DELETE FROM QUERY_MASTER WHERE CODE='cerebral_palsy_retrieve_pnc_danger_signs_by_id';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'4ef5e920-d857-4f39-bf8e-7f7edb68c173', 75398,  current_date , 75398,  current_date , 'cerebral_palsy_retrieve_pnc_danger_signs_by_id', 
'id', 
'select string_agg(value,'','') as "pncDangerSigns" from listvalue_field_value_detail where id in
(select distinct child_danger_signs from rch_pnc_child_danger_signs_rel where child_pnc_id in 
(select id from rch_pnc_child_master where child_id = #id#))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='cerebral_palsy_retrieve_wpd_danger_signs_by_id';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'291f5583-01e4-4a72-a39a-9ea06ba471aa', 75398,  current_date , 75398,  current_date , 'cerebral_palsy_retrieve_wpd_danger_signs_by_id', 
'id', 
'select string_agg(value,'','') as "wpdDangerSigns" from listvalue_field_value_detail where id in
(select distinct danger_signs from rch_wpd_child_danger_signs_rel where wpd_id in 
(select id from rch_wpd_child_master where member_id = #id#))', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='cerebral_palsy_update_remarks_and_status';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9daebacf-ddfe-40e1-99c2-4c9f7d52a93f', 75398,  current_date , 75398,  current_date , 'cerebral_palsy_update_remarks_and_status', 
'additionalInfo,id,childId,remarks,status', 
'update rch_child_cp_suspects
set remarks = #remarks#, status=#status#, remarks_date = now()
where child_service_id = #id#;
update imt_member
set additional_info = #additionalInfo# where id = #childId#', 
null, 
false, 'ACTIVE');

-- Manage Teams

DELETE FROM QUERY_MASTER WHERE CODE='mark_team_as_active_or_inactive';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5311d265-04ea-4ba0-9874-b388299127fe', 75398,  current_date , 75398,  current_date , 'mark_team_as_active_or_inactive', 
'teamId,state', 
'update team_master set state = #state#  , modified_on = now() where id = #teamId# ;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='team_user_search_for_selectize_by_role';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ca4e01ec-8c57-4805-a1f4-9c4d36030b24', 75398,  current_date , 75398,  current_date , 'team_user_search_for_selectize_by_role', 
'searchString,roleIds,teamTypeId', 
'with exclude_user as(
	select tmd.user_id from team_master tm inner join team_member_det tmd on tm.id = tmd.team_id and tmd.state =''ACTIVE'' and tm.state = ''ACTIVE'' where tmd.role_id in(#roleIds#) and tm.team_type_id = #teamTypeId#
)
select um_user.id,
first_name as "firstName", 
last_name as "lastName", 
user_name as "userName", 
um_user.role_id as "roleId",
um_role_master.name as "roleName"
from um_user 
inner join um_role_master on um_role_master.id = um_user.role_id
where um_user.role_id in (#roleIds#) and  um_user.id not in (select * from exclude_user) and
( first_name like CONCAT( ''%'',#searchString#,''%'') or last_name like CONCAT(''%'',#searchString#,''%'') or user_name like CONCAT(''%'',#searchString#)  ) 
limit 50', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrive_team_type_location';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'cfd58875-9a37-497f-ab52-2b3c367e096c', 75398,  current_date , 75398,  current_date , 'retrive_team_type_location', 
'teamTypeId', 
'select * from team_type_location_management where team_type_id = #teamTypeId# and state = ''ACTIVE'';', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrive_team_by_team_type_and_location';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ac346a00-8502-4fea-80e9-20329b7b4d4a', 75398,  current_date , 75398,  current_date , 'retrive_team_by_team_type_and_location', 
'teamTypeId,locationId', 
'select tm.id, tm.name ,tm.team_type_id as "teamTypeId" 
from team_master tm  
inner join team_location_master  tlm on tm.id =  tlm.team_id
where tm.team_type_id = #teamTypeId# and  cast( #locationId# as integer) in (tlm.location_id) and tm.state=''ACTIVE'';', 
null, 
true, 'ACTIVE');