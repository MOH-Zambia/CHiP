delete from system_configuration where system_key = 'DELL_API_PUSH_DATA_DNHDD_STATE_ID';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('DELL_API_PUSH_DATA_DNHDD_STATE_ID', true, 126);

delete from system_configuration where system_key = 'DELL_API_PUSH_DATA_URI';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('DELL_API_PUSH_DATA_URI', true,'https://ncd-staging.nhp.gov.in/v1/kpiService/kpiMessage');