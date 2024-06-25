DELETE FROM QUERY_MASTER WHERE CODE='unlock_user_option';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'df6baa6f-1116-4045-b7c2-acdf02ec1c42', 97053,  current_date , 97053,  current_date , 'unlock_user_option', 
'userId', 
'update um_user set no_of_attempts = 0 where id = #userId# returning id;', 
'N/A',
true, 'ACTIVE');