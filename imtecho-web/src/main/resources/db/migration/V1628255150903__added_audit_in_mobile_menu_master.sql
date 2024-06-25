DELETE FROM QUERY_MASTER WHERE CODE='update_insert_mobile_menu_master';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'36897008-3d53-4b60-9102-77d6c0858300', 74841,  current_date , 74841,  current_date , 'update_insert_mobile_menu_master', 
'config_json,designationIds,menu_name,userId', 
'delete from mobile_menu_role_relation 
where role_id in (select cast(unnest(string_to_array(''#designationIds#'', '','')) as integer));

with menu_master as (
INSERT INTO mobile_menu_master
	(menu_name, config_json, created_on, created_by, modified_on , modified_by) 
	VALUES (
        ''#menu_name#'', ''#config_json#'', now(), ''#userId#'', now(), ''#userId#''
    )
  returning id
)
INSERT INTO mobile_menu_role_relation(menu_id, role_id)
select (select id from menu_master), cast(unnest(string_to_array(''#designationIds#'', '','')) as integer) ;', 
null, 
false, 'ACTIVE');