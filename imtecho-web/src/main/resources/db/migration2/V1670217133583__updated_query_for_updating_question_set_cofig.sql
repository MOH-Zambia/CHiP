DELETE FROM QUERY_MASTER WHERE CODE='update_tr_question_set_configuration';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3c7e1c6d-1382-4d97-bc02-c7a973dc1fd3', 97070,  current_date , 97070,  current_date , 'update_tr_question_set_configuration',
'quizAtSecond,refType,refId,questionSetType,loggedInUserId,id,minimumMarks,courseId,questionSetName,status',
'with update_question_config as (
	UPDATE tr_question_set_configuration
	SET ref_id=#refId#,
	ref_type=#refType#,
	question_set_name=#questionSetName#,
	question_set_type=#questionSetType#,
	status=#status#,
	minimum_marks=#minimumMarks#,
	course_id=#courseId#,
	quiz_at_second=#quizAtSecond#,
	modified_by=#loggedInUserId#,
	modified_on=now()
	WHERE id=#id#
)
update tr_question_set_configuration set minimum_marks = #minimumMarks#, modified_by=#loggedInUserId#, modified_on = now()
where ref_id = #refId# and ref_type = #refType# and course_id = #courseId#
and question_set_type = #questionSetType#',
null,
false, 'ACTIVE');