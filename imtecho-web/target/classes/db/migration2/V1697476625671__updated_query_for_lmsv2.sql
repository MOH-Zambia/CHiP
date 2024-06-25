DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_top_scorers_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b5b5b9a8-123a-41a3-9838-28b800318a92', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_top_scorers_v2',
'courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id in (select id from location_master where type=''S'')
), practice_quizzes as (
	select course_id,
	cast(quiz_config.key as integer) as question_set_type,
	cast(quiz_config.value ->> ''doYouWantAQuizToBeMarked'' as boolean) as is_quiz
	from tr_course_master,
	jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
	where (#courseId# is null or tr_course_master.course_id = #courseId#) and tr_course_master.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
),marks as (
	select tr_question_set_configuration.ref_id,
	tr_question_set_configuration.ref_type,
	tr_question_set_configuration.question_set_type,
	tr_question_set_answer.user_id,
	coalesce(tr_question_set_answer.marks_scored * 100 / tr_question_set_configuration.total_marks,0) as per_scored
	from tr_question_set_answer
	inner join tr_question_set_configuration on tr_question_set_answer.question_set_id = tr_question_set_configuration.id
	inner join practice_quizzes on tr_question_set_configuration.question_set_type = practice_quizzes.question_set_type
	and practice_quizzes.is_quiz
	where (#courseId# is null or tr_question_set_configuration.course_id = #courseId#)
	and tr_question_set_configuration.status = ''ACTIVE''
)select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
coalesce(cast(avg(per_scored) as integer),0) as score
from marks
inner join location_user on location_user.user_id=marks.user_id
inner join um_user on marks.user_id = um_user.id
and um_user.state = ''ACTIVE''
group by um_user.id
order by score desc',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_modules_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7cafe994-1ce7-44ba-a477-2c3219d18d36', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_modules_by_course_id_v2',
'courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id in (select id from location_master where type=''S'')
),
modules as (
    select topic_id as module_id,
        topic_name as module_name,
        topic_order as module_order
    from tr_topic_master
    where topic_id in (
            select topic_id
            from tr_course_topic_rel
            WHERE (#courseId# is null or course_id = #courseId# ) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE''))
                and topic_state = ''ACTIVE''
),
frequency as (
    select modules.module_id,
        count(1) as frequency
    from tr_session_analytics
        inner join tr_topic_media_master on tr_session_analytics.lesson_id = tr_topic_media_master.id
        inner join modules on tr_topic_media_master.topic_id = modules.module_id
        inner join location_user on tr_session_analytics.user_id = location_user.user_id
    group by modules.module_id
),
hours_spent as (
    select module_id,
        extract(
            hour
            from sum(spent_time)
        ) as hours_spent
    from tr_lesson_analytics
        inner join location_user on tr_lesson_analytics.user_id = location_user.user_id
    where module_id in (
            select module_id
            from modules
        )
    group by module_id
)
select modules.module_id as "moduleId",
    modules.module_name as "moduleName",
    modules.module_order as "moduleOrder",
    coalesce(frequency.frequency, 0) as "frequency",
    coalesce(hours_spent.hours_spent, 0) as "hoursSpent"
from modules
    left join frequency on modules.module_id = frequency.module_id
    left join hours_spent on modules.module_id = hours_spent.module_id
order by "frequency" desc,
    "hoursSpent" desc',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_lessons_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'34a32686-5b34-4d3c-b292-d99db7f4702e', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_lessons_by_course_id_v2',
'courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id in (select id from location_master where type=''S'')
    group by user_id
), lessons as (
	select id as lesson_id,
	title as lesson_name,
	media_type as lesson_type,
	media_order as lesson_order
	from tr_topic_media_master
	where topic_id in (select topic_id from tr_course_topic_rel where
 (#courseId# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE''))
	and media_state = ''ACTIVE''
),frequency as (
	select lessons.lesson_id,
	count(1) as frequency
	from tr_session_analytics
	inner join lessons on tr_session_analytics.lesson_id = lessons.lesson_id
    inner join location_user on tr_session_analytics.user_id = location_user.user_id
	group by lessons.lesson_id
),hours_spent as (
	select lesson_id,
	extract(hour from sum(spent_time)) as hours_spent
	from tr_lesson_analytics
    inner join location_user on tr_lesson_analytics.user_id = location_user.user_id
	where lesson_id in (select lesson_id from lessons)
	group by lesson_id
)select lessons.lesson_id as "lessonId",
lessons.lesson_name as "lessonName",
lessons.lesson_type as "lessonType",
coalesce(frequency.frequency,0) as "frequency",
coalesce(hours_spent.hours_spent,0) as "hoursSpent"
from lessons
left join frequency on lessons.lesson_id = frequency.lesson_id
left join hours_spent on lessons.lesson_id = hours_spent.lesson_id
order by "frequency" desc',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_quizzes_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ec9a6b97-cac6-42e7-b00a-d91fe8ee4851', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_quizzes_by_course_id_v2',
'courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id in (select id from location_master where type=''S'')
), practice_quizzes as (
	select course_id,
	cast(quiz_config.key as integer) as question_set_type,
	cast(quiz_config.value ->> ''doYouWantAQuizToBeMarked'' as boolean) as is_quiz
	from tr_course_master,
	jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
	where (#courseId# is null or tr_course_master.course_id = #courseId#) and tr_course_master.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
),quiz_data as (
	select tr_question_set_configuration.ref_id as reference_id,
	tr_question_set_configuration.ref_type as reference_type,
	tr_question_set_configuration.question_set_type as set_type,
	concat(
		case when tr_question_set_configuration.ref_type = ''LESSON''
			 then tr_topic_media_master.title
			 when tr_question_set_configuration.ref_type = ''MODULE''
			 then tr_topic_master.topic_name
			 when tr_question_set_configuration.ref_type = ''COURSE''
			 then tr_course_master.course_name
			 end,
		'' ('',
		listvalue_field_value_detail.value,
		'')''
	) as name
	from tr_question_set_configuration
	left join tr_topic_media_master on tr_question_set_configuration.ref_id = tr_topic_media_master.id
	and tr_question_set_configuration.ref_type = ''LESSON''
	and tr_topic_media_master.media_state = ''ACTIVE''
	left join tr_topic_master on tr_question_set_configuration.ref_id = tr_topic_master.topic_id
	and tr_question_set_configuration.ref_type = ''MODULE''
	and tr_topic_master.topic_state = ''ACTIVE''
	left join tr_course_master on tr_question_set_configuration.ref_id = tr_course_master.course_id
	and tr_question_set_configuration.ref_type = ''COURSE''
	inner join practice_quizzes on tr_question_set_configuration.course_id = practice_quizzes.course_id
	and practice_quizzes.is_quiz
	inner join listvalue_field_value_detail on tr_question_set_configuration.question_set_type = listvalue_field_value_detail.id
	where (#courseId# is null or tr_question_set_configuration.course_id = #courseId#)
	and tr_question_set_configuration.status = ''ACTIVE''
),quizzes as (
	select max(name) as quiz_name,
	concat(reference_id,''_'',reference_type,''_'',set_type) as quiz_id
	from quiz_data
	group by reference_id,reference_type,set_type
),json_data as (
	select tr_user_meta_data.user_id,
	cast(quiz_meta_data as jsonb) as quiz_meta_data
	from tr_user_meta_data
    inner join location_user on location_user.user_id=tr_user_meta_data.user_id
	where (#courseId# is null or course_id = #courseId#)
),quiz_details as (
	select user_id,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''quizRefId'' as integer) as reference_id,
	jsonb_array_elements(quiz_meta_data) ->> ''quizRefType'' as reference_type,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''quizTypeId'' as integer) as set_type,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''quizAttempts'' as integer) as quiz_attempts,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''quizAttemptsToPass'' as integer) as quiz_attempts_to_pass,
	to_timestamp(cast(jsonb_array_elements(quiz_meta_data) ->> ''lastQuizDate'' as bigint)/1000) as last_given_on,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''scoreWhenPassed'' as integer) as pass_score,
	cast(jsonb_array_elements(quiz_meta_data) ->> ''latestScore'' as integer) as latest_score
	from json_data
),frequency as (
	select concat(reference_id,''_'',reference_type,''_'',set_type) as quiz_id,
	sum(quiz_attempts) as frequency
	from quiz_details
	inner join practice_quizzes on quiz_details.set_type = practice_quizzes.question_set_type
	and practice_quizzes.is_quiz
	group by reference_id,
	reference_type,
	set_type
),first_attempt_scores as (
	select distinct on (
		reference_id,
		reference_type,
		set_type,
		tr_question_set_answer.user_id
	)
	concat(reference_id,''_'',reference_type,''_'',set_type) as quiz_id,
	tr_question_set_answer.user_id,
	tr_question_set_answer.marks_scored * 100 / tr_question_set_configuration.total_marks as avg_score,
	tr_question_set_answer.is_passed
	from quiz_details
	inner join tr_question_set_configuration on quiz_details.reference_id = tr_question_set_configuration.ref_id
	and quiz_details.reference_type = tr_question_set_configuration.ref_type
	and quiz_details.set_type = tr_question_set_configuration.question_set_type
	and tr_question_set_configuration.status = ''ACTIVE''
	inner join tr_question_set_answer on tr_question_set_configuration.id = tr_question_set_answer.question_set_id
	order by reference_id,
	reference_type,
	set_type,
	tr_question_set_answer.user_id,
	tr_question_set_answer.created_on
),avg_score as (
	select quiz_id,
	cast(avg(avg_score) as integer) as avg_score
	from first_attempt_scores
	group by quiz_id
),user_data as (
	select quiz_id,
	count(1) as users_attempted,
	count(1) filter (where is_passed) as users_passed,
	count(1) filter (where is_passed is null or is_passed is false) as users_failed
	from first_attempt_scores
	group by quiz_id
)
select quizzes.quiz_id as "quizId",
quizzes.quiz_name as "quizName",
coalesce(frequency.frequency,0) as "frequency",
coalesce(avg_score.avg_score,0) as "firstAttemptAvgScore",
coalesce(user_data.users_attempted,0) as "totalUsersAttempted",
coalesce(user_data.users_passed,0) as "usersPassed",
coalesce(user_data.users_failed,0) as "usersFailed"
from quizzes
left join frequency on quizzes.quiz_id = frequency.quiz_id
left join avg_score on quizzes.quiz_id = avg_score.quiz_id
left join user_data on quizzes.quiz_id = user_data.quiz_id
order by "frequency" desc',
null,
true, 'ACTIVE');