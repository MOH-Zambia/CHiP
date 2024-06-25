DELETE FROM QUERY_MASTER WHERE CODE='update_listvalues';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'45b9b75e-aeb7-449a-a3c7-72b89cf98509', 97084,  current_date , 97084,  current_date , 'update_listvalues',
'multimediaType,constant,fileSize,loggedInUserId,id,value',
'UPDATE listvalue_field_value_detail
   SET last_modified_by=#loggedInUserId#, last_modified_on=now(),multimedia_type=#multimediaType#,
       value=#value#,constant = #constant#, file_size=#fileSize#
 WHERE id=#id#',
null,
false, 'ACTIVE');