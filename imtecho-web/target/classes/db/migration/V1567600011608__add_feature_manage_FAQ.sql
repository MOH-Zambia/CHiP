INSERT INTO menu_group(
            group_name, active, group_type)
   VALUES ('My Techo', true, 'admin');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)
select 'Manage FAQ','admin',TRUE,'techo.manage.FAQ','{}',id from menu_group where group_name = 'My Techo' and group_type = 'admin';