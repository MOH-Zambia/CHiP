delete from user_menu_item where menu_config_id = (select id from menu_config where menu_name = 'Mobile Menu Management');

delete from menu_config where id in (select id from menu_config where menu_name = 'Mobile Menu Management');

INSERT INTO menu_config
(feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order, uuid)
VALUES(NULL, null, true, true, 'Mobile Menu Management', 'techo.manage.mobileMenuManagement', NULL, 'admin', NULL, NULL, NULL);


DELETE FROM QUERY_MASTER WHERE CODE='insert_update_mobile_menu_master';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'd014dd38-06a9-47b3-9a26-f1bd54233867', 74841,  current_date , 74841,  current_date , 'insert_update_mobile_menu_master', 
'feature_name,mobile_display_name,userId,mobile_constant', 
'INSERT INTO mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by)
VALUES(''#mobile_constant#'',''#feature_name#'', ''#mobile_display_name#'', ''ACTIVE'', now(), ''#userId#'') 
ON CONFLICT (mobile_constant) 
DO 
   UPDATE SET mobile_constant = ''#mobile_constant#'', 
   feature_name = ''#feature_name#'', 
   mobile_display_name = ''#mobile_display_name#'',
   modified_on = now(),
   modified_by = ''#userId#'';', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='check_constant_validity_mobile_feature_master';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'095ca9c1-b995-47eb-80ce-00a1e3bae446', 74841,  current_date , 74841,  current_date , 'check_constant_validity_mobile_feature_master', 
'mobile_constant', 
'select case when count(1) = 1 then false else true end 
as "isValid" from mobile_feature_master
where mobile_constant = ''#mobile_constant#'';', 
null, 
true, 'ACTIVE');
