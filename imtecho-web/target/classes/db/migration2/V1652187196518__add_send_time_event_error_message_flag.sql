---System configuration insert--
delete from system_configuration where system_key = 'EVENT_CONFIG_FAILED_EXECUTION_EXCEPTION_MAIL';
INSERT INTO system_configuration(system_key, is_active, key_value) VALUES ('EVENT_CONFIG_FAILED_EXECUTION_EXCEPTION_MAIL', TRUE, 'true');
