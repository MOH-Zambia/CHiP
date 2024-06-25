
insert into menu_config (menu_name, menu_type, active, navigation_state, feature_json, only_admin, group_id)
select 'Generate Dynamic Template', 'admin', TRUE, 'techo.admin.generateDynamicTemplate', '{}', true, (select id from menu_group where group_name = 'Application Management' and group_type = 'admin')
where not exists (select id from menu_config where navigation_state = 'techo.admin.generateDynamicTemplate' and menu_type = 'admin');
