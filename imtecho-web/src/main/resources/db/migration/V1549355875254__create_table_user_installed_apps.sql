drop table if exists user_installed_apps;
create table user_installed_apps (
    id bigserial,
    user_id bigint,
    imei text,
    uid integer,
    version_name text,
    version_code integer,
    application_name text,
    package_name text,
    installed_date timestamp without time zone,
    last_update_date timestamp without time zone,
    used_date timestamp without time zone,
    recieved_data bigint,
    sent_data bigint,
    primary key(user_id, imei, application_name)
);

alter table um_user 
drop column if exists sdk_version, 
add column sdk_version integer,
drop column if exists free_space_mb, 
add column free_space_mb bigint,
drop column if exists latitude, 
add column latitude text,
drop column if exists longitude, 
add column longitude text;