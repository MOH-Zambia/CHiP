delete from user_menu_item where menu_config_id  in (select id from menu_config mc where menu_name = 'Manage Feature Syncing');

delete from menu_config where menu_name = 'Manage Feature Syncing';

 INSERT INTO menu_config (feature_json,group_id,active,is_dynamic_report,menu_name,navigation_state,sub_group_id,menu_type,only_admin,menu_display_order) 
 select '{}',
 mg.id,
 true,
 NULL,
 'Manage Feature Syncing','techo.manage.featureSync',NULL,'admin',NULL,NULL
 from 
 menu_group mg where group_name = 'Application Management';