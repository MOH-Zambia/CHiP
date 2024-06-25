DELETE FROM QUERY_MASTER WHERE CODE='covid19_update_location_cluster_state';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0b4ec42c-97e8-4da2-a164-f4dc9c10e491', 74841,  current_date , 74841,  current_date , 'covid19_update_location_cluster_state', 
'state,id', 
'update location_cluster_master
set state = #state#
where id = #id#', 
null, 
false, 'ACTIVE');