delete from system_configuration where system_key = 'ABDM_CM_ID';

INSERT INTO public.system_configuration(system_key, is_active, key_value)
    VALUES ('ABDM_CM_ID', true, 'sbx');