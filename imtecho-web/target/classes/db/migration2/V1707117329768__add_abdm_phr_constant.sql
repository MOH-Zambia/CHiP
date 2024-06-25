delete from system_configuration where system_key = 'ABDM_PHR_URL';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_PHR_URL', true, 'https://phrsbx.abdm.gov.in/api');