DELETE FROM QUERY_MASTER WHERE CODE='get_locations_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'86a64620-97fc-480a-98c3-f724824ae5de', 97083,  current_date , 97083,  current_date , 'get_locations_type',
 null,
'select type,name,level from location_type_master where is_active = true',
null,
true, 'ACTIVE');


