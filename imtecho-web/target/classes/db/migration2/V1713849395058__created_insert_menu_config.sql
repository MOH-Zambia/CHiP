DELETE FROM QUERY_MASTER WHERE CODE='insert_menu_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'02b88f90-7a89-499a-bba7-3521912e9dce', 97084,  current_date , 97084,  current_date , 'insert_menu_config', 
'groupUUID,subgroupUUID,navigationState,groupId,menuName,menuType,UUID,featureJson,subgroupId', 
'INSERT INTO menu_config (feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type,"uuid", group_name_uuid, sub_group_uuid)
select case when ''#featureJson#'' <> ''null'' then ''#featureJson#'' else null end,(#groupId#),true, false,''#menuName#'',''#navigationState#'',(#subgroupId#),''#menuType#'',''#UUID#'',case when ''#groupUUID#''<>''null'' then cast(case when''#groupUUID#''=''null'' then null else ''#groupUUID#''  end as uuid) else null end,case when ''#subgroupUUID#''<>''null'' then cast(case when''#subgroupUUID#''=''null'' then null  else ''#subgroupUUID#'' end as uuid) else null end
where not exists (select 1 from menu_config where navigation_state = ''#navigationState#'') returning id;', 
'N/A', 
true, 'ACTIVE');