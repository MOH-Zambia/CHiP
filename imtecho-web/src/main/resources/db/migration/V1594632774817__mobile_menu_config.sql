delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'Mobile Menu Management');

delete from menu_config where id in (select id from menu_config where menu_name = 'Mobile Menu Management');

INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, uuid)
VALUES(NULL, null, true, true, 'Mobile Menu Management', 'techo.manage.mobileMenuManagement', NULL, 'manage', NULL, NULL, NULL);

delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'Mobile Menu Configuration');

delete from menu_config where id in (select id from menu_config where menu_name = 'Mobile Menu Configuration');

INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, uuid)
VALUES(NULL, null, true, true, 'Mobile Menu Configuration', 'techo.manage.mobileMenuConfig', NULL, NULL, NULL, NULL, NULL);

DELETE FROM QUERY_MASTER WHERE CODE='mobile_feature_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd0f06d2e-7e13-43ae-ba02-17bf9bc7ef1c', 74841,  current_date , 74841,  current_date , 'mobile_feature_list', 
 null, 
'select * from mobile_feature_master', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_menu_config_role';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'9472ef61-7480-4fec-bcea-69badb3dc146', 74841,  current_date , 74841,  current_date , 'retrieve_menu_config_role', 
'id', 
'select id,name from um_role_master um
where um.state = ''ACTIVE'' and 
id not in (select distinct role_id from mobile_menu_role_relation
where case when role_id = (case when ''#id#'' != '''' then #id# else -1 end) then false else true end)', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrive_mobile_menu_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'56c1e86c-6bdf-4abe-9b0a-d317b3c207a1', 74841,  current_date , 74841,  current_date , 'retrive_mobile_menu_master', 
'id', 
'with menu_role as (
	select * from mobile_menu_role_relation where role_id = #id#
)
, mobile_menu_fields as (
	select id, menu_name, json_array_elements(cast(config_json as json))->>''mobile_constant'' as mobile_constant,
	json_array_elements(cast(config_json as json))->>''order'' as order_no from mobile_menu_master where id = (select menu_id from menu_role limit 1)
) 
select mmf.*,mfm.feature_name,mfm.state,mmr.role_id from mobile_menu_fields mmf 
left join menu_role mmr on mmr.menu_id = mmf.id
left join mobile_feature_master mfm on mfm.mobile_constant = mmf.mobile_constant
order by order_no', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_insert_mobile_menu_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'36897008-3d53-4b60-9102-77d6c0858300', 74841,  current_date , 74841,  current_date , 'update_insert_mobile_menu_master', 
'config_json,designationIds,menu_name', 
'delete from mobile_menu_role_relation 
where role_id in (select cast(unnest(string_to_array(''#designationIds#'', '','')) as integer));

with menu_master as (
INSERT INTO mobile_menu_master
	(menu_name, config_json) 
	VALUES (
        ''#menu_name#'', ''#config_json#''
    )
  returning id
)
INSERT INTO mobile_menu_role_relation(menu_id, role_id)
select (select id from menu_master), cast(unnest(string_to_array(''#designationIds#'', '','')) as integer) ;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mobile_menu_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'68b5486f-42aa-40c1-ba8a-00a00750ee64', 74841,  current_date , 74841,  current_date , 'mobile_menu_list', 
'search,offset,limit', 
'select 
mr.role_id as id,
mm.menu_name, ur."name" as role_name from mobile_menu_role_relation mr
left join mobile_menu_master mm on mm.id = mr.menu_id
left join um_role_master ur on ur.id = mr.role_id
where case when ''#search#'' = ''null'' or mm.menu_name ilike ''%#search#%'' then 
true else false end
order by mr.menu_id
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='delete_mobile_menu_role_relation';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'e50626c4-cd75-4413-af44-98d42b07909e', 74841,  current_date , 74841,  current_date , 'delete_mobile_menu_role_relation', 
'id', 
'delete from mobile_menu_role_relation 
where role_id = ''#id#''', 
null, 
false, 'ACTIVE');