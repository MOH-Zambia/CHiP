delete from system_configuration where system_key = 'EVENT_CONFIG_FAILED_EXECUTION_EXCEPTION_MAIL';
insert into system_configuration(system_key,is_active,key_value)
values ('EVENT_CONFIG_FAILED_EXECUTION_EXCEPTION_MAIL',true,'true');