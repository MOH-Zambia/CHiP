delete from system_configuration where system_key = 'ABDM_HEALTH_ID_URL2';
update system_configuration set key_value = 'https://healthidsbx.abdm.gov.in/api'
where system_key = 'ABDM_HEALTH_ID_URL';
