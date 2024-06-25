DELETE FROM QUERY_MASTER WHERE CODE='get_min_marks_by_question_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'199dafc1-b0fc-4ef2-b5de-3eb1f06efbb4', 97632,  current_date , 97632,  current_date , 'get_min_marks_by_question_config',
'refType,refId,questionSetType,courseId',
'select minimum_marks from tr_question_set_configuration
where ref_id = #refId# and ref_type = #refType# and course_id = #courseId# and question_set_type = #questionSetType# and status = ''ACTIVE''',
null,
true, 'ACTIVE');