delete from system_configuration where system_key = 'ABDM_HEALTH_ID_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_HEALTH_ID_URL', true, 'https://healthidsbx.ndhm.gov.in/api/v1');

delete from system_configuration where system_key = 'ABDM_DEV_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_DEV_URL', true, 'https://dev.ndhm.gov.in/gateway/v0.5');