INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)  
select 'Training Schedule','manage',TRUE,'techo.training.scheduled','{}',id from menu_group where group_name = 'Training' and group_type = 'manage';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Training Dashboard','dashboard',TRUE,'techo.training.dashboard','{}');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Supervisor Re-Verification','manage',TRUE,'techo.manage.fhsrverification','{}');

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('MO Re-Verification','manage',TRUE,'techo.manage.moverification','{}');

