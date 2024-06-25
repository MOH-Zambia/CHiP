-- function for comment on table or Field
-- DROP FUNCTION comment_on_table_or_field(text,text,text);

CREATE OR REPLACE FUNCTION comment_on_table_or_field (table_name text,field_name text,comment text)
RETURNS text AS $final_statement$
declare
	final_statement text;
begin
	IF field_name is null THEN
    	execute 'comment on table ' || $1::text || ' is ''' ||  cast($3 as text) || ''';';
    	select 'comment on table ' || $1::text || ' is ''' ||  cast($3 as text) || ''';' into final_statement;
    ELSE
    	execute 'comment on column ' || $1::text || ' . ' || $2::text ||  ' is ''' ||  cast($3 as text) || ''';';
    	select 'comment on column ' || $1::text || ' . ' || $2::text ||  ' is ''' ||  cast($3 as text) || ''';' into final_statement;
	END IF;
	return final_statement;
EXCEPTION
	 when others THEN RAISE NOTICE 'Error Occured while Commenting, % % ', $1,$2 ;
	 select 'ERROR  Table ' || $1 || ' Field ' || $2 into final_statement;		
	 return final_statement;
END;
$final_statement$ LANGUAGE plpgsql;




-- 
drop table if exists server_list_master;
create table server_list_master (
	id serial,
	server_name text not null,
	username text not null,
	password text not null,
	host_url text not null,
	is_active boolean,
	primary key (server_name)
);

insert into server_list_master (server_name,username,password,host_url,is_active) values
('DEV','postgres','argusadmin','192.1.200.153',true),
('TESTDEPLOY_P','postgres','q1w2e3R$','172.17.31.222',true),
('TESTDEPLOY_T','postgres','q1w2e3R$','172.17.31.222',true),
('STAGING','postgres','argusadmin','192.1.200.153',true),
('DEMO','postgres','argusadmin','127.0.0.1',true),
('RCH','postgres','q1w2e3R$','172.17.31.222',true);

-- Rename 
ALTER table IF EXISTS system_sync_configuration_access_details
RENAME TO sync_system_configuration_server_access_details;

ALTER table IF EXISTS system_sync_configuration_master
RENAME TO sync_system_configuration_master;

ALTER table IF EXISTS server_feature_mapping_for_syncing
RENAME TO sync_server_feature_mapping_detail;



ALTER table IF EXISTS system_config_sync_access
RENAME TO sync_system_configuration_server_access_details;

ALTER table IF EXISTS system_config_sync
RENAME TO sync_system_configuration_master;

ALTER table IF EXISTS server_feature_mapping_for_syncing
RENAME TO sync_server_feature_mapping_detail;

-- 


DELETE FROM QUERY_MASTER WHERE CODE='get_active_server_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bd6d99e3-0b7b-46e9-b938-1812a3e54d0a', 74840,  current_date , 74840,  current_date , 'get_active_server_list', 
 null, 
'select id,server_name,username,host_url,is_active from server_list_master where is_active = true', 
'Get all the actively available server', 
true, 'ACTIVE');


-- Get only not entered ID in access table 

DELETE FROM QUERY_MASTER WHERE CODE='get_system_sync_configuration_id_from_feature_uuid';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ba40779b-faaf-4373-9c73-83cd2e070f25', 74840,  current_date , 74840,  current_date , 'get_system_sync_configuration_id_from_feature_uuid', 
'featureUUID,server_id', 
'select sync.id from sync_system_configuration_server_access_details scsa right join sync_system_configuration_master sync
on scsa.config_id = sync.id and scsa.server_id = #server_id#
where scsa.config_id is null
and sync.feature_uuid = ''#featureUUID#''', 
'get id from system sync table', 
true, 'ACTIVE');





-- Adde screen for sync server Manage

delete from user_menu_item where menu_config_id  in (select id from menu_config mc where menu_name = 'Sync Server Management');

delete from menu_config where menu_name = 'Sync Server Management';

 INSERT INTO menu_config (feature_json,group_id,active,is_dynamic_report,menu_name,navigation_state,sub_group_id,menu_type,only_admin,menu_display_order) 
 select '{}',
 mg.id,
 true,
 NULL,
 'Sync Server Management','techo.manage.syncServerManage',NULL,'admin',NULL,NULL
 from 
 menu_group mg where group_name = 'Application Management';


-- Remove Query configuration for inserting 'Add server' entry

DELETE FROM QUERY_MASTER WHERE CODE='add_server';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'dc681067-1f35-4276-8825-32052cff80af', 74840,  current_date , 74840,  current_date , 'add_server', 
'server_name,password,is_active,db_name,host,server_type,username', 
'insert into server_list_master (server_name,server_type,db_name,username,password,host_url,is_active) values
(''#server_name#'',''#server_type#'',''#db_name#'',''#username#'',''#password#'',''#host#'',#is_active#) returning server_name', 
'add server  desc', 
true, 'INACTIVE');

delete from query_master where code = 'add_server';


-- add new table for mapping between server and feature for syncing
drop table if exists sync_server_feature_mapping_detail;
create table sync_server_feature_mapping_detail (
	id serial,
	server_id int not null,
	feature_uuid uuid not null,
	is_in_sync boolean,
	primary key (server_id,feature_uuid)
);


-- modified Query master's query for retrieving feature sync details

DELETE FROM QUERY_MASTER WHERE CODE='get_server_list_which_are_in_sync_for_auto_sync_configuration';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0a7d5036-f44c-42b6-81df-d449d1c3ecd3', 74840,  current_date , 74840,  current_date , 'get_server_list_which_are_in_sync_for_auto_sync_configuration', 
'featureUUID', 
'select distinct serv.server_name from sync_server_feature_mapping_detail mapper inner join server_list_master serv on mapper.server_id = serv.id
where mapper.feature_uuid = ''#featureUUID#''', 
'get list of all the server which are set for syncing respective feature config
and not in sync', 
true, 'ACTIVE');


-- Remove two columns from access table and added server_id instead of server_name

alter table sync_system_configuration_server_access_details drop column if exists type;
alter table sync_system_configuration_server_access_details drop column if exists feature_uuid;

alter table sync_system_configuration_server_access_details drop column if exists server_name;
alter table sync_system_configuration_server_access_details drop column if exists server_id;
alter table sync_system_configuration_server_access_details add column server_id int4;


-- Get Feature Name for common screen syncing
DELETE FROM QUERY_MASTER WHERE CODE='get_feature_name_with_uuid';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ccd5e720-f4db-4407-b2ef-0e1dc7d8c759', 74840,  current_date , 74840,  current_date , 'get_feature_name_with_uuid', 
 null, 
'with unique_uuid as (
	select 
	distinct on (feature_uuid ) 
	feature_uuid,feature_name,feature_type 
	from sync_system_configuration_master scs where feature_uuid is not null 
	order by feature_uuid,id desc
)
,server_id_merger as (
	select
	u.feature_uuid,
	feature_name,
	feature_type,
	string_agg(cast(master.id as text),'','') as server_ids,
	string_agg(master.server_name,'','') as server_names
	from unique_uuid u
	left join sync_server_feature_mapping_detail map on map.feature_uuid = u.feature_uuid
	left join server_list_master master on map.server_id = master.id 
	group by u.feature_uuid,u.feature_name,u.feature_type
)
select cast(feature_uuid as text) as feature_uuid,feature_name,feature_type,server_names,server_ids from server_id_merger', 
'get feature name', 
true, 'ACTIVE');

-- update Server Config fetching URl

update system_configuration set key_value = 'http://localhost:8181/api/systemconfigsync/load/config?id=#id#&serverPassword=#password#' where 
system_key = 'SERVER_URL_FROM_WHERE_NEED_TO_FETCH_CONFIG_JSON_FOR_SYS_SYNC';


-- update server password of list_server
DELETE FROM QUERY_MASTER WHERE CODE='update_list_server_password';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'c4b908be-b5f9-428c-8b4a-6c6abcf2296a', 74840,  current_date , 74840,  current_date , 'update_list_server_password', 
'password,id', 
'update server_list_master set password = ''#password#'' where id = #id# returning id;', 
null, 
true, 'ACTIVE');

/*-- Remove ID and is_in_sync from Mapper
alter table sync_server_feature_mapping_detail drop column if exists id;
alter table sync_server_feature_mapping_detail drop column if exists is_in_sync;
*/


/*

-- Added server_name and password in system configuration 
-- For Production server Need to update again with respective server
delete from system_configuration where system_key = 'SERVER_NAME';
insert into system_configuration (system_key,is_active,key_value) values ('SERVER_NAME',true,'DEV');

delete from system_configuration where system_key = 'SERVER_PASSWORD';
insert into system_configuration (system_key,is_active,key_value) values ('SERVER_PASSWORD',true,'argusadmin');
-- 
*/