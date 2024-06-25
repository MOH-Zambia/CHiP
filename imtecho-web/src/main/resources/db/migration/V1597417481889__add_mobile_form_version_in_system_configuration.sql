delete from system_configuration where system_key = 'MOBILE_FORM_VERSION';

insert into system_configuration(system_key, key_value, is_active)
values('MOBILE_FORM_VERSION', '1', true);