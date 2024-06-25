-- query to retrieve exceptions in event by event configuration id
DELETE FROM QUERY_MASTER WHERE CODE='event_config_retrieve_exceptions_by_config_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'550bd005-d939-4953-bc04-8859f433193b', 80208,  current_date , 80208,  current_date , 'event_config_retrieve_exceptions_by_config_id', 
'configId', 
'select te.id 
, te.event_config_id  as "eventConfigId"
, te.exception_string as "exceptionString"
,te.processed 
, te.processed_on as "processedOn"
, te.system_trigger_on as "systemTriggerOn"
from timer_event te where te.status = ''EXCEPTION'' and te.event_config_id = #configId#;', 
null, 
true, 'ACTIVE');