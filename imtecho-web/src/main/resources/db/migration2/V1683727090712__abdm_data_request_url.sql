delete from system_configuration where system_key = 'ABDM_DATA_REQUEST_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_DATA_REQUEST_URL', true, 'https://demo.medplat.org/v0.5/ndhm/data');