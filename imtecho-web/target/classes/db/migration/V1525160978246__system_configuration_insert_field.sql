delete from system_configuration where system_key = 'SERVER_TYPE';
INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('SERVER_TYPE', true,'P');

delete from system_configuration where system_key = 'TRAINING_DB_NAME';
INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('TRAINING_DB_NAME', true,'techo_t');
