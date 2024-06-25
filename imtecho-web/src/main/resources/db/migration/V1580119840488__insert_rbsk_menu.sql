INSERT INTO menu_group(
            group_name, active, group_type)
   VALUES ('RBSK', true, 'admin');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)
select 'Configure RBSk defects','admin',TRUE,'techo.manage.configureRbskDefects','{}',id from menu_group where group_name = 'RBSK' and group_type = 'admin';