
INSERT INTO menu_group(
            group_name, active, group_type)
    VALUES ( 'User Managment', true, 'manage');

INSERT INTO menu_group(
            group_name, active, group_type)
    VALUES ( 'Training', true, 'manage');

delete from user_menu_item where menu_config_id in (select id from menu_config where menu_name = 'Dashboard');

delete from menu_config where menu_name = 'Dashboard';

update menu_config set group_id = (select id from menu_group where group_name = 'User Managment' and group_type = 'manage') 
where menu_name in ('Users','Menu');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('FHS Dashboard','dashboard',TRUE,'techo.dashboard.fhs','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)  
select 'Role','manage',TRUE,'techo.manage.role','{}',id from menu_group where group_name = 'User Managment' and group_type = 'manage';

update menu_config set navigation_state = 'techo.manage.users', feature_json ='{}' where menu_name = 'Users' and menu_type = 'manage';
