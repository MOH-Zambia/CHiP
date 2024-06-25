delete from system_configuration where system_key = 'ABDM_HPR_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_HPR_URL', true, 'https://hpridsbx.abdm.gov.in/api/');

delete from system_configuration where system_key = 'ABDM_HFR_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_HFR_URL', true, 'https://facilitysbx.abdm.gov.in/v1.5');

delete from system_configuration where system_key = 'ABDM_DEV_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_DEV_URL', true, 'https://dev.ndhm.gov.in/gateway');