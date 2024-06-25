alter table anganwadi_master 
    add column alias_name varchar(255);

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Manage Anganwadis','manage',TRUE,'techo.manage.anganwadi','{}');
