delete from system_configuration where system_key = 'ABDM_BENEFIT_ID';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_BENEFIT_ID', true, 'TECHO_GUJARAT');