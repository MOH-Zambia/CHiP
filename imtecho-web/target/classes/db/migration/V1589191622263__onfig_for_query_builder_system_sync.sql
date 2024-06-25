-- Query Builder 

ALTER TABLE query_master
DROP COLUMN IF EXISTS UUID;

ALTER TABLE query_master 
ADD COLUMN UUID UUID;


create table if not exists system_config_sync (
id  SERIAL NOT NULL,
feature_type text not null,
config_json text,
created_on timestamp without time zone,
created_by integer,
primary key (id,feature_type) 
);

delete from system_configuration where system_key = 'LAST_ID_TILL_JSON_CONFIG_PROCESSED_FOR_SYSTEM_SYNC';
insert into system_configuration (system_key,is_active,key_value) values ('LAST_ID_TILL_JSON_CONFIG_PROCESSED_FOR_SYSTEM_SYNC',true,0);


delete from system_configuration where system_key = 'SERVER_URL_FROM_WHERE_NEED_TO_FETCH_CONFIG_JSON_FOR_SYS_SYNC';
insert into system_configuration (system_key,is_active,key_value) values ('SERVER_URL_FROM_WHERE_NEED_TO_FETCH_CONFIG_JSON_FOR_SYS_SYNC',true,'http://localhost:8181/api/systemconfigsync/load/config?id=#id#&limit=#limit#');


