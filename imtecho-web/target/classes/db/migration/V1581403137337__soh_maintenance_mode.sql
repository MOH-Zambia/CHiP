-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3138

delete from public.system_configuration where system_key = 'SOH_MAINTENANCE_MODE_ENABLE';

insert into public.system_configuration (system_key, is_active, key_value) VALUES('SOH_MAINTENANCE_MODE_ENABLE', true, 'false');

-- generic queries to retrieve and update system configuration value by key

-- get

delete from query_master where code='retrieve_system_configuration_by_key';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'retrieve_system_configuration_by_key', 'key','
    SELECT
    system_key as "key",
    is_active as "isActive",
    key_value as "value"
    FROM public.system_configuration
    WHERE system_key = ''#key#'';
', true, 'ACTIVE', 'Retrieve System Configuration Details By Key');

-- post

delete from query_master where code='update_system_configuration_by_key';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'update_system_configuration_by_key', 'key,value,isActive','
    UPDATE public.system_configuration
    SET
    is_active = #isActive#,
    key_value = ''#value#''
    WHERE system_key = ''#key#'';
', false, 'ACTIVE', 'Update System Configuration Details By Key');
