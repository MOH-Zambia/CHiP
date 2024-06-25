DELETE FROM QUERY_MASTER WHERE CODE='system_config_add';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
           'aead829e-f8e5-4f31-989e-61c1fec8a875', 97070,  current_date , 97070,  current_date , 'system_config_add',
           'value,key',
           'insert into system_configuration(key_value,system_key,is_active) values (#value#,#key#,false)',
           'Add system configuration',
           false, 'ACTIVE');

UPDATE menu_config
SET feature_json = '{"canAdd":false}'
WHERE navigation_state = 'techo.manage.systemconfigs';

DELETE FROM QUERY_MASTER WHERE CODE='check_if_system_configuration_exists';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
           'c14ded9a-1657-4d84-9a57-455f865e5c44', 97070,  current_date , 97070,  current_date , 'check_if_system_configuration_exists',
           'key',
           'SELECT COUNT(*) FROM SYSTEM_CONFIGURATION
           WHERE system_key = #key#',
           'Checks whether the system configuration exists or not',
           true, 'ACTIVE');