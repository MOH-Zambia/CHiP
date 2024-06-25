DELETE FROM QUERY_MASTER WHERE CODE='update_menu_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'950ef14b-9a3d-4c1a-8670-da7f85178e73', 97084,  current_date , 97084,  current_date , 'update_menu_config', 
'navigationState,groupId,featureType,menuName,menuType,featureJson,featureId,subgroupId', 
'UPDATE menu_config 
SET feature_json = case when ''#featureJson#''<>''null'' then ''#featureJson#'' else null end, group_id= (#groupId#),menu_name = ''#menuName#'', navigation_state= ''#navigationState#'' ,
sub_group_id= (#subgroupId#), menu_type= ''#menuType#''
WHERE id = #featureId# and menu_type = ''#featureType#'' and not exists (select 1 from menu_config where navigation_state = ''#navigationState#'' and id<>#featureId#) returning id;', 
'N/A', 
true, 'ACTIVE');