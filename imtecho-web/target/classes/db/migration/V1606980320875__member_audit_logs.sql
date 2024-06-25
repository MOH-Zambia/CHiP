DELETE FROM QUERY_MASTER WHERE CODE='member_information_change_audit_log';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'61b542fc-bff9-4898-8cd0-6e31bc57c572', 79677,  current_date , 79677,  current_date , 'member_information_change_audit_log', 
'offset,column,limit,search_text', 
'select concat( im.first_name, '' '', im.middle_name, '' '', im.last_name, ''('' , unique_health_id , '')'') as "memberDetail", 
case 
when #column# = ''gender'' then (case when mal.data ->> ''gender'' = ''M'' then ''Male'' when mal.data ->> ''gender'' = ''F'' then ''Female''  else ''Other'' end)
when #column# = ''place_of_birth'' then INITCAP(
case when data ->> ''place_of_birth'' in (''108_AMBULANCE'', ''HOME'',
''ON_THE_WAY'',
''OUT_OF_STATE_GOVT'',
''OUT_OF_STATE_PVT'') then REPLACE(data ->> ''place_of_birth'', ''_'', '' '')
when data ->> ''place_of_birth'' = ''HOSP'' then ''HOSPITAL''
when data ->> ''place_of_birth'' is null then ''-''
else data ->> ''place_of_birth'' end 
)
when #column# = ''health_infrastructure_id'' then INITCAP(
case when data ->> ''delivery_place'' in (''108_AMBULANCE'', ''HOME'',
''ON_THE_WAY'',
''OUT_OF_STATE_GOVT'',
''OUT_OF_STATE_PVT'') then REPLACE(data ->> ''delivery_place'', ''_'', '' '')
when data ->> ''delivery_place'' = ''HOSP'' then ''HOSPITAL''
when data ->> ''delivery_place'' is null then ''-''
else data ->> ''delivery_place'' end 
)
when #column# = ''state'' then mal.data ->> ''state''
else cast(to_char(cast(data ->> #column# as date), ''DD/MM/YYYY'') as text) end as "modifiedField", 
to_char(mal.created_on, ''DD/MM/YYYY'') as "createdOn",  
u.first_name || '' '' || u.last_name || '' ('' || u.user_name || '')'' || ''<br>'' 
	|| ''Contact : '' || case when u.contact_number is not null then u.contact_number else ''N/A'' end as "userInfo",
mal.document_id as "documentId" 
from member_audit_log mal
inner join imt_member im on im.id = mal.member_id 
left join um_user u on u.id = mal.user_id
where mal.column_name = #column#
and ((#search_text# is null) or (#search_text# = '''') or (unique_health_id ilike concat(''%'',#search_text#,''%''))) 
order by mal.id
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='helpdesk_update_member_dob';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'20483f2d-5a84-4a94-900f-ed6c372b40bc', 66522,  current_date , 66522,  current_date , 'helpdesk_update_member_dob', 
'dob,loggedInUserId,memberId', 
'with preg_mother_id as (
	select
	child.wpd_mother_id, mot.member_id
	from rch_wpd_child_master child
	left join rch_wpd_mother_master mot on child.wpd_mother_id = mot.id
	where child.member_id = #memberId#
)
,member_dob as (
	select dob from imt_member where id = #memberId#
)
,twin_brother_info as(
	select rch_wpd_child_master.member_id from rch_wpd_child_master, preg_mother_id
	where rch_wpd_child_master.wpd_mother_id = preg_mother_id.wpd_mother_id
	union
	select #memberId#
)
, insert_member_audit_log as (
 	insert into member_audit_log (member_id,table_name,data,user_id,column_name,ref_code)
	select id,''imt_member'',row_to_json(lm) as data, #loggedInUserId# as user_id,''dob'',lm.id
	from (select id,dob from imt_member where id in(select member_id from twin_brother_info)) lm
	returning member_id
)
, update_member_dob_immmun_in_imt_member as (
	update imt_member set dob = #dob#, immunisation_given = null, modified_by = #loggedInUserId#, modified_on = current_timestamp
	from twin_brother_info where id = twin_brother_info.member_id
	returning id
)
, delete_immun as (
	delete from rch_immunisation_master where member_id in (select member_id from twin_brother_info) and member_type = ''C''
	returning id
)
, update_mobile_noti_child as (
	update event_mobile_notification_pending
	set base_date = #dob# ,	modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id in (select member_id from twin_brother_info)
	and state=''PENDING''
	and notification_configuration_type_id in (''f51c8c4f-6b2b-4dcb-8e64-ada1a3044a67'',''dfa2b7ee-0ae4-4d5e-bb8e-20252905ebc6'')
	returning id
)
,delete_techo_noti_child as (
	delete from techo_notification_master
	where notification_type_id = 4
	and member_id in (select member_id from twin_brother_info) and state in (''PENDING'',''RESCHEDULE'')
	returning id
),
update_date_of_del_child as (
	update rch_wpd_child_master
	set date_of_delivery = #dob#,  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id in (select member_id from twin_brother_info)
	returning id
),
update_date_of_del_mother as (
	 update rch_wpd_mother_master
	set date_of_delivery = #dob#,  modified_by = #loggedInUserId#, modified_on = current_timestamp
	where id = (select wpd_mother_id from preg_mother_id)
	returning id
),
update_mobile_noti_mother as (
	update event_mobile_notification_pending
	set base_date = #dob#, 	modified_by = #loggedInUserId#, modified_on = current_timestamp
	where member_id = (select member_id from preg_mother_id)
	and state=''PENDING''
	and notification_configuration_type_id in (select id from event_configuration_type
					where mobile_notification_type = (select id from notification_type_master where code = (''FHW_PNC'')))
	returning id
)
,delete_techo_noti_mother as (
	delete from techo_notification_master
	where notification_type_id = (select id from notification_type_master where code = (''FHW_PNC''))
	and member_id in (select member_id from twin_brother_info) and state in (''PENDING'',''RESCHEDULE'')
	returning id
)
update imt_member mother
set last_delivery_date = #dob#, modified_by = #loggedInUserId#, modified_on = current_timestamp
from member_dob,preg_mother_id
where mother.id = preg_mother_id.member_id
and to_char(mother.last_delivery_date, ''dd/mm/yyyy'') = to_char(member_dob.dob, ''dd/mm/yyyy'');', 
null, 
false, 'ACTIVE');

delete from user_menu_item
where menu_config_id = (select id from menu_config where  menu_name  = 'Member Details Audit Log');

delete from menu_config where  menu_name  = 'Member Details Audit Log';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json, group_id) values 
('Member Details Audit Log','admin',TRUE,'techo.manage.memberInfoChangeAuditLog','{}', (select id from menu_group mg where group_name = 'Administration'));