delete from user_menu_item where menu_config_id=(select id from menu_config where menu_name='Manage WPD visit');
delete from user_menu_item where menu_config_id=(select id from menu_config where menu_name='WPD Institional form');
delete from user_menu_item where menu_config_id=(select id from menu_config where menu_name='WPD Search');
delete from user_menu_item where menu_config_id=(select id from menu_config where menu_name='WPD institutional form');
delete from menu_config where menu_name='Manage WPD visit';
delete from menu_config where menu_name='WPD Institional form';
delete from menu_config where menu_name='WPD Search';
delete from menu_config where menu_name='WPD institutional form';
insert into menu_config(active,menu_name,navigation_state,menu_type) values('TRUE','WPD Institution Form','techo.manage.wpdSearch','manage');