INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json,group_id)  
select 'Trainee Status','manage',TRUE,'techo.training.traineeStatus','{}',id from menu_group where group_name = 'Training' and group_type = 'manage';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Call Centre Verification','manage',TRUE,'techo.dashboard.gvkverification','{}');

