DELETE FROM query_master where code='retrieve_all_staff_sms';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'retrieve_all_staff_sms', NULL, 'with staff_sms as(
select id, jsonb_array_elements(cast(user_list as jsonb))->> ''mobileNumber'' as elem from sms_staff_sms_master
)
select sm.id, sm.name, sm.sms_template as "smsTemplate", sm.trigger_type as "triggerType", sm.schedule_date_time as "dateTime", 
sm.state, sm.status, sm.config_type as "configType",
(select CONCAT(u.first_name, '' '', u.last_name, '' ('', u.user_name, '')'')as "createdUserName" from um_user u where id = sm.created_by and state = ''ACTIVE'') ,
 sm.created_on, count(sc.elem) as "userCount"
from sms_staff_sms_master sm 
left join staff_sms sc on sc.id = sm.id 
group by sm.id,sm.created_on, sm.sms_template, sm.trigger_type, sm.schedule_date_time, "createdUserName", sm.config_type,
sm.state, sm.status, sm.name
order by created_on desc', true, 'ACTIVE', NULL);


DELETE FROM query_master where code='retrieve_staff_sms_by_userid';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'retrieve_staff_sms_by_userid', 'userId', 'with staff_sms as(
select id, jsonb_array_elements(cast(user_list as jsonb))->> ''mobileNumber'' as elem from sms_staff_sms_master
)
select sm.id, sm.name, sm.sms_template as "smsTemplate", sm.trigger_type as "triggerType", sm.schedule_date_time as "dateTime", 
sm.state, sm.status,  sm.config_type as "configType",
(select CONCAT(u.first_name, '' '', u.last_name, '' ('', u.user_name, '')'')as "createdUserName" from um_user u where id = sm.created_by and state = ''ACTIVE'') ,
  sm.created_on, count(sc.elem) as "userCount"
from sms_staff_sms_master sm 
left join staff_sms sc on sc.id = sm.id 
where created_by = ''#userId#''
group by sm.id,sm.created_on, sm.sms_template, sm.trigger_type, sm.schedule_date_time, "createdUserName", sm.config_type,
sm.state, sm.status, sm.name
order by created_on desc', true, 'ACTIVE', NULL);


DELETE FROM query_master where code='retrieve_staff_sms_user_sms_status_list';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'retrieve_staff_sms_user_sms_status_list', 'staffSmsConfigId', 'with staff_sms as(
select id, config_type, jsonb_array_elements(cast(user_list as jsonb)) as elem from sms_staff_sms_master where id = ''#staffSmsConfigId#''
)
select sc.id,sc.config_type as "configType", sm.id as "smsId", sc.elem->>''mobileNumber'' as "mobileNumber", sc.elem->>''smsQueueId'' as "smsQueueId" ,
case when sc.config_type = ''ROLE_LOCATION_BASED'' then
(select CONCAT(u.first_name, '' '', u.last_name,'' ('', u.user_name, '')'') from um_user u where id = cast(sc.elem->>''userId'' as Integer) and state = ''ACTIVE'')
end  as "userName",
case when sq.sms_id is not null and sm.carrier_status is not null then sm.carrier_status else ''N.A.''end as "smsStatus"
from staff_sms sc
left join sms_queue sq on cast(sc.elem->>''smsQueueId'' as Integer) = sq.id
left join sms sm on sm.id = sq.sms_id', true, 'ACTIVE', NULL);
