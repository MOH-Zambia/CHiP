DELETE FROM QUERY_MASTER WHERE CODE='health_infras_retrival_by_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'999df8cf-4841-4f34-a777-58cda7a2f527', 97575,  current_date , 97575,  current_date , 'health_infras_retrival_by_type',
'types',
'select h.id as id , h.name as name from health_infrastructure_details h where h.type in #types# and h.state = ''ACTIVE'';',
'retrieves health infras by type',
true, 'ACTIVE');