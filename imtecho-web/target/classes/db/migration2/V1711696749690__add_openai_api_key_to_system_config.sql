DELETE FROM system_configuration where system_key='OPENAI_API_KEY';

INSERT INTO system_configuration (system_key, is_active, key_value) values ('OPENAI_API_KEY', true, '');