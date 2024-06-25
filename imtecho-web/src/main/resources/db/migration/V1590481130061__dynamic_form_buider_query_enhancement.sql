DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_configs_select_by_formid';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'b358c003-7818-4445-96db-5be3cdfb9bca', 75398,  current_date , 75398,  current_date , 'dynamic_form_configs_select_by_formid', 
'form_id', 
'select * from system_form_configuration where form_id=#form_id#;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_config_select_by_id';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'97f822e9-90c0-457b-9890-4c03af6304b1', 75398,  current_date , 75398,  current_date , 'dynamic_form_config_select_by_id', 
'id', 
'select * from system_form_configuration where id = #id#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_select_by_id';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'627be70a-a6c2-4a63-a9a0-075aed4036f5', 75398,  current_date , 75398,  current_date , 'dynamic_form_select_by_id', 
'id', 
'select * from system_form_master where id = #id#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_select_by_code';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c89ecb43-96b8-432f-a340-bf9ea6e5ca7b', 75398,  current_date , 75398,  current_date , 'dynamic_form_select_by_code', 
'code', 
'select * from system_form_master where form_code ilike #code#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_update_data';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'7e83059f-1a9b-4984-b265-deccd7e17280', 75398,  current_date , 75398,  current_date , 'dynamic_form_update_data', 
'loggedInUserId,id,form_name,form_code', 
'update system_form_master
set form_name =#form_name# ,
form_code =#form_code# ,
modified_on = now(),
modified_by =  #loggedInUserId#
where id = #id#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_insert_data';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6f9dbd56-1925-4390-b178-f57c026680b6', 75398,  current_date , 75398,  current_date , 'dynamic_form_insert_data', 
'loggedInUserId,form_name,form_code', 
'insert into system_form_master(form_name,form_code, created_by, created_on, modified_on, modified_by)
values(
#form_name#, #form_code#, 
''#loggedInUserId#'', now(), now(), ''#loggedInUserId#''
)
returning id;', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_config_insert_data';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'078e314a-09fc-4b58-a318-6ef34d52b468', -1,  current_date , -1,  current_date , 'dynamic_form_config_insert_data', 
'form_id,form_config_json,loggedInUserId,version', 
'insert into system_form_configuration(version,form_id, form_config_json, created_by, created_on, modified_on, modified_by)
values(
#version#, #form_id#, #form_config_json#,
#loggedInUserId#, now() , now() , #loggedInUserId#
)', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='dynamic_form_config_update_data';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5fc0203a-0179-41d6-a4e8-8259a827bf6f', 75398,  current_date , 75398,  current_date , 'dynamic_form_config_update_data', 
'form_id,form_config_json,loggedInUserId,id,version', 
'update system_form_configuration
set version =#version# ,
form_id =#form_id# ,
form_config_json =#form_config_json# ,
modified_on = now() ,
modified_by =  ''#loggedInUserId#''
where id = #id#', 
null, 
false, 'ACTIVE');