DELETE FROM public.system_configuration
	WHERE system_key='SERVER_URL';
INSERT INTO public.system_configuration(
	system_key, is_active, key_value)
	VALUES ('SERVER_URL', true, 'https://demo.medplat.org');

DELETE FROM public.system_configuration
	WHERE system_key='ABDM_HEALTH_ID_URL2';
INSERT INTO public.system_configuration(
	system_key, is_active, key_value)
	VALUES ('ABDM_HEALTH_ID_URL2', true, 'https://healthidsbx.abdm.gov.in/api/v2');