alter table system_configuration
alter column key_value type text;

delete from system_configuration
where system_key = 'SYSTEM_NOTICE';

insert into system_configuration(system_key,is_active,key_value)
values ('SYSTEM_NOTICE',false,'Notice');