DELETE FROM QUERY_MASTER WHERE CODE='get_feature_name_with_uuid';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'ccd5e720-f4db-4407-b2ef-0e1dc7d8c759', 74840,  current_date , 74840,  current_date , 'get_feature_name_with_uuid', 
 null, 
'select cast(feature_uuid as text) as uuid,string_agg(cast (id as text),'','') as config_ids,feature_name,feature_type from system_sync_configuration_master where feature_uuid is not null group by feature_uuid,feature_name,feature_type', 
'get feature name', 
true, 'ACTIVE');