DELETE FROM QUERY_MASTER WHERE CODE='insert_listvalues';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'136eee66-c5d5-4455-9858-cde74048045f', 97084,  current_date , 97084,  current_date , 'insert_listvalues',
'multimediaType,constant,fieldKey,fileSize,loggedInUserId,value',
'INSERT INTO listvalue_field_value_detail(is_active, is_archive, last_modified_by, last_modified_on, multimedia_type,value,constant,field_key,file_size) VALUES (true, false, #loggedInUserId# , now() ,
#multimediaType#, #value# , #constant#, #fieldKey# , #fileSize# );',
null,
false, 'ACTIVE');