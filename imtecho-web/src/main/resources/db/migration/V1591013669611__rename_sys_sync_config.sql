/*ALTER table IF EXISTS system_config_sync
RENAME TO system_sync_configuration_master;


ALTER table IF EXISTS system_config_sync_access
RENAME TO system_sync_configuration_access_details;


drop table if exists system_sync_configuration_master;

create table if not exists system_sync_configuration_master (
id  SERIAL NOT NULL,
feature_uuid UUID NOT NULL,
feature_name text NOT NULL,
feature_type text not null,
config_json text NOT NULL,
created_on timestamp without time zone NOT NULL,
created_by integer NOT NULL,
primary key (id,feature_type) 
);
*/

DELETE FROM QUERY_MASTER WHERE CODE='get_system_sync_configuration_id_from_feature_uuid';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ba40779b-faaf-4373-9c73-83cd2e070f25', 74840,  current_date , 74840,  current_date , 'get_system_sync_configuration_id_from_feature_uuid', 
'featureUUID', 
'select id from system_sync_configuration_master scs where feature_uuid  = ''#featureUUID#'' order by id asc;', 
'get id from system sync table', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_server_list_which_are_in_sync_for_auto_sync_configuration';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0a7d5036-f44c-42b6-81df-d449d1c3ecd3', 74840,  current_date , 74840,  current_date , 'get_server_list_which_are_in_sync_for_auto_sync_configuration', 
'isInSync,featureUUID', 
'select distinct server_name from system_sync_configuration_access_details scsa where feature_uuid = ''#featureUUID#'' 
and is_in_sync = #isInSync#;', 
'get list of all the server which are set for syncing respective feature config', 
true, 'ACTIVE');