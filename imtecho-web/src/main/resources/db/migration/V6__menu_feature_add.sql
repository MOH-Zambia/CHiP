delete from menu_config;

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Users','manage',TRUE,'techo.manage.user','{"canAdd":false,"canEdit":false}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Course','manage',TRUE,'techo.manage.course','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Dashboard','dashboard',TRUE,'techo.home','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Menu','manage',TRUE,'techo.manage.menu','{}');