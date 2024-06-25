delete from public.system_configuration where system_key = 'ELASTIC_LOCATION_INDEX_NAME';
INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('ELASTIC_LOCATION_INDEX_NAME', true,'idx_location');

delete from public.system_configuration where system_key = 'ELASTIC_MEMBER_INDEX_NAME';
INSERT INTO public.system_configuration(
            system_key, is_active, key_value)
    VALUES ('ELASTIC_MEMBER_INDEX_NAME', true,'idx_member');