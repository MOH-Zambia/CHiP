UPDATE query_master SET query = REPLACE(query, 'public.', ''), modified_by=1, modified_on=NOW()::timestamp;

UPDATE report_query_master SET query = REPLACE(query, 'public.', ''), modified_by=1, modified_on=NOW()::timestamp;

UPDATE event_configuration SET config_json = REPLACE(config_json, 'public.', ''), modified_by=1, modified_on=NOW()::timestamp;
