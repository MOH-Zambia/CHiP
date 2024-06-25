DELETE FROM QUERY_MASTER WHERE CODE='location_lgd_code_check';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'94ca6d46-757f-4a35-a9c1-fa85c64954d9', 74841,  current_date , 74841,  current_date , 'location_lgd_code_check', 
'lgdCode', 
'select case when count(1) > 1 then true else false end as is_present from location_master where lgd_code = cast(#lgdCode# as text);', 
null, 
true, 'ACTIVE');