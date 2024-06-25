delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Manage System Configurations');

delete from menu_config where id in (select id from menu_config where menu_name = 'Manage System Configurations');

INSERT INTO public.menu_config
( feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order)
VALUES( '{}', (select id from menu_group where group_name = 'Application Management' and group_type = 'admin'), true, NULL, 'Manage System Configurations', 'techo.manage.systemconfigs', NULL, 'admin', NULL, NULL);

DELETE FROM QUERY_MASTER WHERE CODE='system_configs_retrieve_all';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
80208,  current_date , 80208,  current_date , 'system_configs_retrieve_all',
 null,
'SELECT sc.system_key "key" , sc.key_value "value",sc.is_active "state" from system_configuration sc;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='system_config_update';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
80208,  current_date , 80208,  current_date , 'system_config_update',
'oldKey,isActive,value,key',
'update system_configuration set key_value = ''#value#'' , system_key = ''#key#'', is_active = #isActive# where system_configuration.system_key = ''#oldKey#''',
'update system configuration',
false, 'ACTIVE');

