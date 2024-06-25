drop TABLE IF EXISTS  public.system_form_master;

CREATE TABLE public.system_form_master (
	id serial NOT NULL,
	form_name varchar(1024) NULL,
	form_code varchar(1024) NULL,
	created_by int4 NOT NULL,
	created_on timestamp NOT NULL,
	modified_by int4 NOT NULL,
	modified_on timestamp NOT NULL,
	CONSTRAINT system_form_master_pkey PRIMARY KEY (id)
);


DROP TABLE IF EXISTS public.system_form_configuration;

CREATE TABLE public.system_form_configuration (
	id serial NOT NULL,
	form_id integer,
        form_config_json text NULL,
        version varchar(250),
	created_by int4 NOT NULL,
	created_on timestamp NOT NULL,
	modified_by int4 NOT NULL,
	modified_on timestamp NOT NULL,
	CONSTRAINT system_form_configuration_pkey PRIMARY KEY (id)
);


Delete from menu_config where menu_name='Dynamic Form Builder';

INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('Dynamic Form Builder','admin',TRUE,'techo.manage.dynamicform','{}');




Delete from query_master where code='dynamic_form_config_insert_data';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_config_insert_data', 'modified_on,created_on,form_id,form_config_json,modified_by,version,created_by', 'insert into system_form_configuration(version,form_form_config_json, created_by, created_on, modified_on, modified_by)
values(
''#version#'', ''#form_id#'', ''#form_config_json#'',
''#created_by#'', ''#created_on#'', ''#modified_on#'', ''#modified_by#''
)', false, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_config_select_by_id';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_config_select_by_id', 'id', 'select * from system_form_configuration where id = ''#id#''', true, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_config_update_data';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_config_update_data', 'modified_on,form_id,form_config_json,modified_by,id,version', 'update system_form_configuration
set version =''#version#'' ,
form_id =''#form_id#'' ,
form_config_json =''#form_config_json#'' ,
modified_on = ''#modified_on#'' ,
modified_by =  ''#modified_by#''
where id = ''#id#''', false, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_configs_select_by_formid';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_configs_select_by_formid', 'form_id', 'select * from system_form_configuration where form_id=''#form_id#'';', true, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_insert_data';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_insert_data', 'modified_on,created_on,modified_by,form_name,created_by,form_code', 'insert into system_form_master(form_name,form_code, created_by, created_on, modified_on, modified_by)
values(
''#form_name#'', ''#form_code#'', 
''#created_by#'', ''#created_on#'', ''#modified_on#'', ''#modified_by#''
)
returning id;', true, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_select_all';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_select_all', NULL, 'select * from system_form_master;', true, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_select_by_id';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_select_by_id', 'id', 'select * from system_form_master where id = ''#id#''', true, 'ACTIVE', NULL, NULL);

Delete from query_master where code='dynamic_form_update_data';

INSERT INTO public.query_master
(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state, description, is_public)
VALUES(1, now(), 1, now(), 'dynamic_form_update_data', 'modified_on,modified_by,id,form_name,form_code', 'update system_form_master
set form_name =''#form_name#'' ,
form_code =''#form_code#'' ,
modified_on = ''#modified_on#'' ,
modified_by =  ''#modified_by#''
where id = ''#id#''', false, 'ACTIVE', NULL, NULL);


