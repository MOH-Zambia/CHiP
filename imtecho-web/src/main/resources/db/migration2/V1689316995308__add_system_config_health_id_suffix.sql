delete from system_configuration where system_key = 'HEALTH_ID_SUFFIX';

INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('HEALTH_ID_SUFFIX', true, '@sbx');

delete from system_configuration where system_key = 'ABDM_HIU_ID';

insert into system_configuration (system_key, is_active, key_value)
    values ('ABDM_HIU_ID', true, 'TeCHO-HIU');