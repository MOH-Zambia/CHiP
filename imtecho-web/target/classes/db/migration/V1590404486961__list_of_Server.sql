delete from listvalue_field_value_detail where field_key = 'SERVER_LIST';

delete from listvalue_field_master where field_key = 'SERVER_LIST';

insert  into listvalue_field_master(field_key ,field ,is_active,field_type )
values ('SERVER_LIST','list_of_all_the_Server',true,'T');

insert into listvalue_field_value_detail (is_active,is_archive,last_modified_by,last_modified_on,value,field_key,file_size)
values
(true,false,'akhokhariya',now(),'DEV','SERVER_LIST',0),
(true,false,'akhokhariya',now(),'TESTDROP','SERVER_LIST',0),
(true,false,'akhokhariya',now(),'STAGING','SERVER_LIST',0),
(true,false,'akhokhariya',now(),'DEMO','SERVER_LIST',0),
(true,false,'akhokhariya',now(),'LIVE','SERVER_LIST',0),
(true,false,'akhokhariya',now(),'RCH','SERVER_LIST',0);


DELETE FROM QUERY_MASTER WHERE CODE='get_active_server_list';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bd6d99e3-0b7b-46e9-b938-1812a3e54d0a', 74840,  current_date , 74840,  current_date , 'get_active_server_list', 
 null, 
'select value from listvalue_field_value_detail where field_key = ''SERVER_LIST'' and is_active = true', 
'Get all the actively available server', 
true, 'ACTIVE');

alter table system_config_sync drop column if exists feature_id;

alter table system_config_sync add column uuid UUID;

alter table system_config_sync drop column if exists feature_name;

alter table system_config_sync add column feature_name text;

drop table if exists system_config_sync_access;

create table if not exists system_config_sync_access (
	id serial,
	config_id int4,
	type text,
	server_name text,
	feature_uuid UUID,
	is_in_sync boolean
);

DELETE FROM QUERY_MASTER WHERE CODE='get_server_list_which_are_in_sync_for_auto_sync_configuration';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0a7d5036-f44c-42b6-81df-d449d1c3ecd3', 74840,  current_date , 74840,  current_date , 'get_server_list_which_are_in_sync_for_auto_sync_configuration', 
'isInSync,featureUUID', 
'select distinct server_name from system_config_sync_access scsa where feature_uuid = ''#featureUUID#'' 
and is_in_sync = #isInSync#;', 
'get list of all the server which are set for syncing respective feature config', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_system_sync_configuration_id_from_feature_uuid';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ba40779b-faaf-4373-9c73-83cd2e070f25', 74840,  current_date , 74840,  current_date , 'get_system_sync_configuration_id_from_feature_uuid', 
'featureUUID', 
'select id from system_config_sync scs where feature_uuid  = ''#featureUUID#'' order by id asc;', 
'get id from system sync table', 
true, 'ACTIVE');