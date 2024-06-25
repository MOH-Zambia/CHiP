ALTER TABLE tr_question_set_configuration
ADD COLUMN IF NOT EXISTS is_allowed_to_attempt_quiz_without_completing_lessons boolean default false;

DELETE FROM QUERY_MASTER WHERE CODE='get_tr_question_set_configuration_by_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8334fcd3-34d9-4caa-8f67-198e646d5b52', 97074,  current_date , 97074,  current_date , 'get_tr_question_set_configuration_by_id',
'id',
'SELECT
tqsc.id,
tqsc.ref_id as "refId",
tqsc.ref_type as "refType",
tqsc.question_set_name as "questionSetName",
tqsc.question_set_type as "questionSetType",
list.value as "questionSetTypeName",
tqsc.status,
tqsc.minimum_marks as "minimumMarks",
tqsc.total_marks as "totalMarks",
tqsc.quiz_at_second as "quizAtSecond",
tqsc.is_allowed_to_attempt_quiz_without_completing_lessons as "isAllowedToAttemptQuiz",
tcm.course_id as "courseId",
tcm.course_name as "courseName",
ttm.topic_id as "topicId",
ttm.topic_name as "topicName",
ttvm.id as "mediaId",
ttvm.title as "mediaName"
FROM
tr_question_set_configuration tqsc
left join tr_course_master tcm on
    case
        when tqsc.ref_type = ''COURSE'' then tqsc.ref_id = tcm.course_id
        when tqsc.ref_type = ''MODULE'' then (select course_id from tr_course_topic_rel where topic_id = tqsc.ref_id) = tcm.course_id
        when tqsc.ref_type = ''LESSON'' then (select course_id from tr_course_topic_rel where topic_id = (select topic_id from tr_topic_media_master where id = tqsc.ref_id)) = tcm.course_id
        else false
    end
left join tr_topic_master ttm on
    case
        when tqsc.ref_type = ''MODULE'' then tqsc.ref_id = ttm.topic_id
        when tqsc.ref_type = ''LESSON'' then (select topic_id from tr_topic_media_master where id = tqsc.ref_id) = ttm.topic_id
        else false
    end
left join tr_topic_media_master ttvm on
    case
        when tqsc.ref_type = ''LESSON'' then tqsc.ref_id = ttvm.id
        else false
    end
left join listvalue_field_value_detail list on list.id = tqsc.question_set_type
where tqsc.id = #id#;',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_into_tr_question_set_configuration';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b5fd4d27-97be-42c1-8644-b3165f470cfc', 97074,  current_date , 97074,  current_date , 'insert_into_tr_question_set_configuration',
'quizAtSecond,refType,refId,questionSetType,isAllowedToAttemptQuiz,loggedInUserId,minimumMarks,courseId,questionSetName,status',
'INSERT INTO tr_question_set_configuration
(ref_id, ref_type, question_set_name, question_set_type, status, minimum_marks, course_id, quiz_at_second, is_allowed_to_attempt_quiz_without_completing_lessons, created_by, created_on, modified_by, modified_on)
VALUES
(#refId#, #refType#, #questionSetName#, #questionSetType#, #status#, #minimumMarks#, #courseId#, #quizAtSecond#, #isAllowedToAttemptQuiz#, #loggedInUserId#, now(), #loggedInUserId#, now());',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_tr_question_set_configuration';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3c7e1c6d-1382-4d97-bc02-c7a973dc1fd3', 97074,  current_date , 97074,  current_date , 'update_tr_question_set_configuration',
'quizAtSecond,refType,refId,questionSetType,isAllowedToAttemptQuiz,loggedInUserId,id,minimumMarks,courseId,questionSetName,status',
'UPDATE tr_question_set_configuration
SET ref_id=#refId#,
ref_type=#refType#,
question_set_name=#questionSetName#,
question_set_type=#questionSetType#,
status=#status#,
minimum_marks=#minimumMarks#,
course_id=#courseId#,
quiz_at_second=#quizAtSecond#,
is_allowed_to_attempt_quiz_without_completing_lessons=#isAllowedToAttemptQuiz#,
modified_by=#loggedInUserId#,
modified_on=now()
WHERE id=#id#;

UPDATE tr_question_set_configuration set minimum_marks = #minimumMarks#, modified_by=#loggedInUserId#, modified_on = now()
WHERE ref_id = #refId# and ref_type = #refType# and course_id = #courseId# and question_set_type = #questionSetType#;',
null,
false, 'ACTIVE');