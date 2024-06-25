DELETE FROM QUERY_MASTER
WHERE CODE = 'retrieve_lms_course_list';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '625a6086-ed54-4a65-a6f8-8209e70a98a0',
        58981,
        current_date,
        58981,
        current_date,
        'retrieve_lms_course_list',
        null,
        'select course_id as "courseId",
course_name as "courseName"
from tr_course_master
where course_state = ''ACTIVE''
and course_type = ''ONLINE''',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_modules_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'e338408e-f1f5-4d51-9048-787ec1ff920f',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_modules_by_course_id',
        'courseId',
        'with modules as (
	select topic_id as module_id,
	topic_name as module_name,
	topic_order as module_order
	from tr_topic_master
	where topic_id in (select topic_id from tr_course_topic_rel where course_id = #courseId#)
	and topic_state = ''ACTIVE''
),frequency as (
	select modules.module_id,
	count(1) as frequency
	from tr_session_analytics
	inner join tr_topic_media_master on tr_session_analytics.lesson_id = tr_topic_media_master.id
	inner join modules on tr_topic_media_master.topic_id = modules.module_id
	group by modules.module_id
),hours_spent as (
	select module_id,
	extract(hour from sum(spent_time)) as hours_spent
	from tr_lesson_analytics
	where module_id in (select module_id from modules)
	group by module_id
)select modules.module_id as "moduleId",
modules.module_name as "moduleName",
modules.module_order as "moduleOrder",
coalesce(frequency.frequency,0) as "frequency",
coalesce(hours_spent.hours_spent,0) as "hoursSpent"
from modules
left join frequency on modules.module_id = frequency.module_id
left join hours_spent on modules.module_id = hours_spent.module_id
order by "frequency" desc, "hoursSpent" desc',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_lessons_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '85dc642c-f05b-412c-84bb-b6763c1e464c',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_lessons_by_course_id',
        'courseId',
        'with lessons as (
	select id as lesson_id,
	title as lesson_name,
	media_type as lesson_type,
	media_order as lesson_order
	from tr_topic_media_master
	where topic_id in (select topic_id from tr_course_topic_rel where course_id = #courseId#)
	and media_state = ''ACTIVE''
),frequency as (
	select lessons.lesson_id,
	count(1) as frequency
	from tr_session_analytics
	inner join lessons on tr_session_analytics.lesson_id = lessons.lesson_id
	group by lessons.lesson_id
),hours_spent as (
	select lesson_id,
	extract(hour from sum(spent_time)) as hours_spent
	from tr_lesson_analytics
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
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_enrolled_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '33b040e5-cd17-4765-acf5-5179a8302654',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_enrolled_by_course_id',
        'offSet,limit,courseId',
        'with users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
),course_status as (
	select users.enrolled_user_id as enrolled_user_id,
	tr_user_meta_data.user_id as user_id,
	tr_user_meta_data.is_course_completed
	from users
	left join tr_user_meta_data on users.enrolled_user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
),course_time as (
	select user_id,
	min(started_on) as course_started_on,
	max(ended_on) as course_ended_on
	from tr_lesson_analytics
	where course_id = #courseId#
	group by user_id
)
select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
case when course_status.user_id is null then ''NOT_YET_STARTED''
	 when course_status.user_id is not null and (course_status.is_course_completed is null or course_status.is_course_completed is false) then ''IN_PROGRESS''
	 when course_status.user_id is not null and course_status.is_course_completed is true then ''COMPLETED''
	 end as "courseStatus",
to_char(course_time.course_started_on,''DD/MM/YYYY HH24:MI:SS'') as "courseStartedOn",
to_char(course_time.course_ended_on,''DD/MM/YYYY HH24:MI:SS'') as "courseEndedOn"
from users
inner join um_user on users.enrolled_user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''
inner join course_status on users.enrolled_user_id = course_status.enrolled_user_id
left join course_time on users.enrolled_user_id = course_time.user_id
order by um_user.id
limit #limit# offset #offSet#',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_quizzes_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '60eb2f3d-375c-4db0-ae79-504f37863f3b',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_quizzes_by_course_id',
        'courseId',
        'with practice_quizzes as (
	select course_id,
	cast(quiz_config.key as integer) as question_set_type,
	cast(quiz_config.value ->> ''doYouWantAQuizToBeMarked'' as boolean) as is_quiz
	from tr_course_master,
	jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
	where tr_course_master.course_id = #courseId#
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
	where tr_question_set_configuration.course_id = #courseId#
	and tr_question_set_configuration.status = ''ACTIVE''
),quizzes as (
	select max(name) as quiz_name,
	concat(reference_id,''_'',reference_type,''_'',set_type) as quiz_id
	from quiz_data
	group by reference_id,reference_type,set_type
),json_data as (
	select user_id,
	cast(quiz_meta_data as jsonb) as quiz_meta_data
	from tr_user_meta_data
	where course_id = #courseId#
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
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_course_engagement';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '45bc05a7-726c-41cf-a18c-c39f6cca6f76',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_course_engagement',
        'courseId',
        'with enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
),enrolled_data as (
	select enrolled_users.enrolled_user_id as user_id,
	um_user.role_id as role_id
	from enrolled_users
	inner join um_user on enrolled_users.enrolled_user_id = um_user.id
	and um_user.state = ''ACTIVE''
),roles as (
	select distinct role_id
	from enrolled_data
),total as (
	select roles.role_id,
	count(1) as total
	from roles
	inner join um_user on roles.role_id = um_user.role_id
	and um_user.state = ''ACTIVE''
	group by roles.role_id
),enrolled as (
	select enrolled_data.role_id as role_id,
	count(1) as enrolled
	from enrolled_data
	group by enrolled_data.role_id
),course_status as (
	select enrolled_data.role_id as role_id,
	count(1) filter (where (is_course_completed is null or is_course_completed is false)) as in_progress,
	count(1) filter (where is_course_completed) as completed
	from enrolled_data
	inner join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
	group by enrolled_data.role_id
),not_started as (
	select enrolled_data.role_id,
	count(1) filter (where tr_user_meta_data.user_id is null) as not_started
	from enrolled_data
	left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
	group by enrolled_data.role_id
)
select um_role_master.id as "roleId",
um_role_master.name as "roleName",
coalesce(total.total,0) as "total",
coalesce(enrolled.enrolled,0) as "enrolled",
coalesce(not_started.not_started,0) as "notStarted",
coalesce(course_status.in_progress,0) as "inProgress",
coalesce(course_status.completed,0) as "completed"
from roles
left join total on roles.role_id = total.role_id
left join enrolled on roles.role_id = enrolled.role_id
left join course_status on roles.role_id = course_status.role_id
left join not_started on roles.role_id = not_started.role_id
inner join um_role_master on roles.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_not_accessed_7_days';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'e03078ac-3c80-4426-a44b-04948b89d733',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_not_accessed_7_days',
        'courseId',
        'select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
case when tr_user_meta_data.last_accessed_lesson_on > tr_user_meta_data.last_accessed_quiz_on
	 then concat(
	 	to_char(tr_user_meta_data.last_accessed_lesson_on,''DD/MM/YYYY HH24:MI:SS''),
	 	'' (-'',
	 	cast(extract(day from (current_date - last_accessed_lesson_on)) as text),
	 	'' days)''
	 )
	 else concat(
	 	to_char(tr_user_meta_data.last_accessed_quiz_on,''DD/MM/YYYY HH24:MI:SS''),
	 	'' (-'',
	 	cast(extract(day from (current_date - last_accessed_quiz_on)) as text),
	 	'' days)''
	 )
	 end as "lastAccessedOn",
concat(tr_course_wise_count_analytics.course_progress,''%'') as "courseProgress"
from tr_user_meta_data
inner join um_user on tr_user_meta_data.user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''
left join tr_course_wise_count_analytics on tr_user_meta_data.user_id = tr_course_wise_count_analytics.user_id
and tr_user_meta_data.course_id = tr_course_wise_count_analytics.course_id
where tr_user_meta_data.course_id = #courseId#
and (is_course_completed is null or is_course_completed is false)
and coalesce(extract(day from (current_date - last_accessed_lesson_on)),0) > 7
and coalesce(extract(day from (current_date - last_accessed_quiz_on)),0) > 7',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_comprehension_effectiveness';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '69dec614-b24a-4e52-8b94-b806c921ec25',
        97070,
        current_date,
        97070,
        current_date,
        'lms_dashboard_retrieve_comprehension_effectiveness',
        'quizId,courseId',
        'with practice_quizzes as (
	select course_id,
	cast(quiz_config.key as integer) as question_set_type,
	cast(quiz_config.value ->> ''doYouWantAQuizToBeMarked'' as boolean) as is_quiz
	from tr_course_master,
	jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
	where tr_course_master.course_id = #courseId#
),data as (
	select case when #quizId# = ''-1'' then null else cast(split_part(#quizId#,''_'',1) as integer) end as reference_id,
	case when #quizId# = ''-1'' then null else split_part(#quizId#,''_'',2) end as reference_type,
	case when #quizId# = ''-1'' then null else cast(split_part(#quizId#,''_'',3) as integer) end as set_type
),questions as (
	select tr_question_set_configuration.id,
	tr_question_set_configuration.ref_id,
	tr_question_set_configuration.ref_type,
	tr_question_set_configuration.question_set_type,
	tr_question_set_configuration.total_marks
	from tr_question_set_configuration
	inner join practice_quizzes on tr_question_set_configuration.question_set_type = practice_quizzes.question_set_type
	and practice_quizzes.is_quiz
	where (
		#quizId# = ''-1''
		or (
			tr_question_set_configuration.ref_id in (select reference_id from data)
			and tr_question_set_configuration.ref_type in (select reference_type from data)
			and tr_question_set_configuration.question_set_type in (select set_type from data)
		)
	)
	and tr_question_set_configuration.status = ''ACTIVE''
	and tr_question_set_configuration.course_id = #courseId#
),marks_scored as (
	select questions.ref_id,
	questions.ref_type,
	questions.question_set_type,
	tr_question_set_answer.user_id,
	max(cast(tr_question_set_answer.marks_scored * 100 / questions.total_marks as integer)) as score
	from tr_question_set_answer
	inner join questions on tr_question_set_answer.question_set_id = questions.id
	group by questions.ref_id,
	questions.ref_type,
	questions.question_set_type,
	tr_question_set_answer.user_id
),average_score as (
	select user_id,
	avg(score) as score
	from marks_scored
	group by user_id
)
select count(1) filter (where score > 80) as "greaterThan80",
count(1) filter (where score between 40 and 80) as "between40_80",
count(1) filter (where score < 40) as "lesserThan40"
from average_score',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_top_scorers';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '60b8b838-b241-4892-8b52-c77f0e362a72',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_top_scorers',
        'courseId',
        'with practice_quizzes as (
	select course_id,
	cast(quiz_config.key as integer) as question_set_type,
	cast(quiz_config.value ->> ''doYouWantAQuizToBeMarked'' as boolean) as is_quiz
	from tr_course_master,
	jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
	where tr_course_master.course_id = #courseId#
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
	where tr_question_set_configuration.course_id = #courseId#
	and tr_question_set_configuration.status = ''ACTIVE''
)select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
coalesce(cast(avg(per_scored) as integer),0) as score
from marks
inner join um_user on marks.user_id = um_user.id
and um_user.state = ''ACTIVE''
group by um_user.id
order by score desc',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_course_completors';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'fe74a3c5-5c52-4d64-bb15-2bb52d774a85',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_course_completors',
        'courseId',
        'with course_completion as (
	select tr_lesson_analytics.user_id as user_id,
	sum(spent_time) as spent_time,
	min(tr_lesson_analytics.started_on) as course_started_on,
	max(tr_lesson_analytics.ended_on) as course_ended_on
	from tr_lesson_analytics
	inner join tr_user_meta_data on tr_lesson_analytics.user_id = tr_user_meta_data.user_id
	and tr_lesson_analytics.course_id = tr_user_meta_data.course_id
	where tr_lesson_analytics.course_id = #courseId#
	and tr_user_meta_data.is_course_completed
	group by tr_lesson_analytics.user_id
)select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
concat(
	case when (extract(day from spent_time) * 24 + extract(hour from spent_time)) <= 0
		 then ''''
		 else concat(extract(day from spent_time) * 24 + extract(hour from spent_time),'' hr '')
		 end,
	case when extract(minute from spent_time) <= 0
		 then ''''
		 else concat(extract(minute from spent_time),'' min '')
		 end,
	case when extract(second from spent_time) <= 0
		 then ''''
		 else concat(extract(second from spent_time),'' sec'')
		 end
) as "spentTime",
concat(
	case when (extract(day from (course_ended_on - course_started_on)) * 24 + extract(hour from (course_ended_on - course_started_on))) <= 0
		 then ''''
		 else concat(extract(day from (course_ended_on - course_started_on)) * 24 + extract(hour from (course_ended_on - course_started_on)),'' hr '')
		 end,
	case when extract(minute from (course_ended_on - course_started_on)) <= 0
		 then ''''
		 else concat(extract(minute from (course_ended_on - course_started_on)),'' min '')
		 end,
	case when extract(second from (course_ended_on - course_started_on)) <= 0
		 then ''''
		 else concat(extract(second from (course_ended_on - course_started_on)),'' sec'')
		 end
) as "finishedIn"
from course_completion
inner join um_user on course_completion.user_id = um_user.id
and um_user.state = ''ACTIVE''
order by (course_ended_on - course_started_on);',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_enrolled_count_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '2c8c0445-6fa7-4e0b-8171-3eb8346d82ea',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_enrolled_count_by_course_id',
        'courseId',
        'with users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
)select count(1) as "totalEnrolled" from users',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_learning_hours_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '8f76045a-31df-4d82-af85-71be977e10fb',
        97067,
        current_date,
        97067,
        current_date,
        'lms_dashboard_retrieve_learning_hours_by_course_id',
        'courseId',
        'select tr_course_master.course_id as "courseId",
cast (sum(tr_lesson_analytics.spent_time)  as time ) as "timeSpent"
from tr_course_master
left join tr_lesson_analytics on tr_course_master.course_id = tr_lesson_analytics.course_id
where tr_course_master.course_id = #courseId#
group by tr_course_master.course_id',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_userwise_watch_hours_by_course_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        'b4563d5c-0f2c-4ef6-b3cc-8ef156098955',
        97067,
        current_date,
        97067,
        current_date,
        'lms_dashboard_retrieve_userwise_watch_hours_by_course_id',
        'courseId',
        'with data as (
	select user_id,
	cast (sum(spent_time)  as time ) as "spent_time"
	from tr_lesson_analytics
	where course_id = #courseId#
	group by user_id
)select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
data.spent_time as "timeSpent"
from data
inner join um_user on data.user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_daywise_engagement_by_module';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '67ce718e-b267-4013-96da-005186b96914',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_daywise_engagement_by_module',
        'topicId,time',
        'with data as (
	select tr_session_analytics.user_id,
	tr_session_analytics.lesson_id,
	cast(tr_session_analytics.started_on as date)
	from tr_session_analytics
	inner join tr_topic_media_master on tr_session_analytics.lesson_id = tr_topic_media_master.id
	where tr_topic_media_master.topic_id = #topicId#
)select to_char(started_on,''DD/MM/YYYY'') as "startedOn",
count(1) as "noOfUsers"
from data
where case when #time# = ''Last 7 Days'' then started_on >= current_date - interval ''7 days''
		   when #time# = ''Last 30 Days'' then started_on >= current_date - interval ''30 days''
		   else true end
group by started_on
order by started_on',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_daywise_engagement_by_lesson';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '484b52a2-9d80-4192-8171-07f808dfb45b',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_daywise_engagement_by_lesson',
        'lessonId,time',
        'with data as (
	select user_id,
	cast(started_on as date)
	from tr_session_analytics
	where lesson_id = #lessonId#
)select to_char(started_on,''DD/MM/YYYY'') as "startedOn",
count(1) as "noOfUsers"
from data
where case when #time# = ''Last 7 Days'' then started_on >= current_date - interval ''7 days''
		   when #time# = ''Last 30 Days'' then started_on >= current_date - interval ''30 days''
		   else true end
group by started_on
order by started_on',
        null,
        true,
        'ACTIVE'
    );
DELETE FROM QUERY_MASTER
WHERE CODE = 'lms_dashboard_retrieve_userwise_quiz_trend_by_quiz_id';
INSERT INTO QUERY_MASTER (
        uuid,
        created_by,
        created_on,
        modified_by,
        modified_on,
        code,
        params,
        query,
        description,
        returns_result_set,
        state
    )
VALUES (
        '77ec6a25-67d9-488f-b578-ff557216f9e2',
        60512,
        current_date,
        60512,
        current_date,
        'lms_dashboard_retrieve_userwise_quiz_trend_by_quiz_id',
        'quizId,time',
        'with data as (
	select cast(split_part(#quizId#,''_'',1) as integer) as reference_id,
	split_part(#quizId#,''_'',2) as reference_type,
	cast(split_part(#quizId#,''_'',3) as integer) as set_type
),first_attempts as (
	select distinct on (tr_question_set_answer.user_id)
	tr_question_set_answer.user_id,
	cast(tr_question_set_answer.created_on as date),
	tr_question_set_answer.is_passed
	from data
	inner join tr_question_set_configuration on data.reference_id = tr_question_set_configuration.ref_id
	and data.reference_type = tr_question_set_configuration.ref_type
	and data.set_type = tr_question_set_configuration.question_set_type
	and tr_question_set_configuration.status = ''ACTIVE''
	inner join tr_question_set_answer on tr_question_set_configuration.id = tr_question_set_answer.question_set_id
	order by tr_question_set_answer.user_id,
	tr_question_set_answer.created_on
)select to_char(created_on,''DD/MM/YYYY'') as "attemptedOn",
count(1) as "totalUsersAttempted",
count(1) filter (where is_passed) as "totalUsersPassed",
count(1) filter (where is_passed is null or is_passed is false) as "totalUsersFailed"
from first_attempts
where case when #time# = ''Last 7 Days'' then created_on >= current_date - interval ''7 days''
		   when #time# = ''Last 30 Days'' then created_on >= current_date - interval ''30 days''
		   else true end
group by created_on',
        null,
        true,
        'ACTIVE'
    );