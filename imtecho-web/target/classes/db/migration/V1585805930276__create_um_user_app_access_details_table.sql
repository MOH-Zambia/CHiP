drop table if exists um_user_app_access_details;

create table um_user_app_access_details (
    id serial primary key,
    user_id integer,
    app_name character varying(30),
    app_version character varying(10),
    device_type character varying(30),
    created_on timestamp without time zone NOT NULL,
    imei_number character varying(100)
);


delete from query_master where code='insert_um_user_app_access_details';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'insert_um_user_app_access_details','userId,appName,appVersion,deviceType,imei','
insert
	into
		um_user_app_access_details( user_id, app_name, app_version, device_type, created_on, imei_number )
	values(#userId#, ''#appName#'', ''#appVersion#'', ''#deviceType#'', current_date, ''#imei#'' )
',false,'ACTIVE');
