delete from system_configuration where system_key = 'DELL_API_PUSH_DATA_API_KEY';
INSERT INTO system_configuration(
	system_key, is_active, key_value)
	VALUES ('DELL_API_PUSH_DATA_API_KEY', true,'abc');

ALTER TABLE public.ncd_dell_api_push_response ADD COLUMN IF NOT EXISTS response_message text NULL;