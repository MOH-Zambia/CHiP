delete from user_menu_item where menu_config_id  in (select id from menu_config mc where menu_name = 'DashboardPOC');

delete from menu_config where menu_name = 'DashboardPOC';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values
('DashboardPOC','manage',TRUE,'techo.manage.dashboardpoc','{}');