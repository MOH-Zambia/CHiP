create table if not EXISTS tp_api_access_log (
	id serial,
	req_body text,
	req_param text,
	res_body text,
	req_time timestamp without time zone,
	req_state text,
	req_error text,
	tp_type text,
	req_remote_ip text
);

delete from system_configuration sc where system_key = 'DIGILOCKER_API_ACCESS_KEY';
insert into system_configuration (system_key,is_active,key_value) values ('DIGILOCKER_API_ACCESS_KEY',true,'107452f2332d375ef5306c70125d2b675163c471f7f3f822a75aaf09ada1bba7');

delete from system_configuration sc where system_key = 'DIGILOCKER_GUJ_ISSUER_ID';
insert into system_configuration (system_key,is_active,key_value) values ('DIGILOCKER_GUJ_ISSUER_ID',true,'techo.gujarat.gov.in');
