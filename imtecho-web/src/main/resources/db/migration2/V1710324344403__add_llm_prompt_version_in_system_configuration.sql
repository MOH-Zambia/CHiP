DELETE FROM system_configuration where system_key = 'LLM_PROMPT_VERSION';

INSERT INTO system_configuration (system_key, is_active, key_value) values('LLM_PROMPT_VERSION', TRUE, 'v1.0');
