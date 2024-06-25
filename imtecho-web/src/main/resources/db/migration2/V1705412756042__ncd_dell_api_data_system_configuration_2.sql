delete from system_configuration where system_key = 'DELL_API_PUSH_DATA_USER_NAME';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('DELL_API_PUSH_DATA_USER_NAME', true,'kpi_dddnh');

delete from system_configuration where system_key = 'DELL_API_PUSH_DATA_PASSWORD';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('DELL_API_PUSH_DATA_PASSWORD', true,'password');