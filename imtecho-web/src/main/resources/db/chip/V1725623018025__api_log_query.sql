CREATE TABLE public.dhis2_api_call_log (
    id BIGSERIAL PRIMARY KEY,
    request_body TEXT,
    response_body TEXT,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    http_status INT,
	month DATE
);

INSERT INTO public.system_configuration(
	system_key, is_active, key_value)
	VALUES ('DHIS2_API_URL', true, 'http://10.51.75.137:8081/hmis-dev/api/dataValueSets');