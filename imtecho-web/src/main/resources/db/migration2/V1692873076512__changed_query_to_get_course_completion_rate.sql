DELETE FROM QUERY_MASTER WHERE CODE='lms_course_engagement_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d15d603-e3f6-42e6-a7d2-fd399b896947', 97070,  current_date , 97070,  current_date , 'lms_course_engagement_data',
'locationId,roleId',
'with counts as(select count(distinct tcwca.user_id) filter(where tcwca.course_progress = 100 ) as users, tcwca.course_id,
avg(time_spent_on_course) as time_spent
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id  and uul.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join um_user uu on uu.id = tcwca.user_id and uu.state=''ACTIVE''
where lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id= cast(#roleId# as integer) else true end group by tcwca.course_id),
course_counts as(select counts.*, tcm.course_name from counts
inner join tr_course_master tcm on tcm.course_id=counts.course_id
where tcm.course_state = ''ACTIVE'' and course_type=''ONLINE''),
course_details as(select count(distinct attendee_id)+count(distinct additional_attendee_id) as enrolled_user_id,ttcr.course_id,tcm.course_name
	from tr_training_attendee_rel ttar
	inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
	left join tr_training_additional_attendee_rel ttaar on ttaar.training_id =ttar .training_id
	inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
	inner join um_user_location uul on ttar.attendee_id = uul.user_id  and uul.state=''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id  and uul2.state=''ACTIVE''
	left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id and lhcd2.parent_id = #locationId#	where tcm.course_state = ''ACTIVE'' and tcm.course_type=''ONLINE''
	and lhcd.parent_id = #locationId#
	group by ttcr.course_id ,tcm.course_name
)
select course_details.course_id,course_details.course_name,
(COALESCE(course_counts.users,0)*100)/course_details.enrolled_user_id as completion_rate,
date_part(''minutes'', time_spent) as time_spent
from course_counts
right join course_details on
course_details.course_id=course_counts.course_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_monthly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0409f66b-1a17-49f2-b8d9-d553fea8ab2e', 97074,  current_date , 97074,  current_date , 'lms_count_of_users_coursewise_monthly',
'locationId,roleId,courseId',
'with base_data as(select count(distinct tsa.user_id),date_trunc(''month'',started_on) as started_on from tr_session_analytics tsa
inner join um_user_location uul on tsa.user_id = uul.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
where lesson_id in (select distinct lesson_id from tr_lesson_analytics tla where (#courseId# is null or course_id = #courseId#)	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')) and lhcd.parent_id =#locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by date_trunc(''month'',started_on)),
months as (select
    generate_series(
        date_trunc(''month'',current_date - interval ''11'' month),
        current_date, ''1 month''
    ) as month)
select months.month, coalesce(base_data.count,0) as count from months
left join base_data on months.month=base_data.started_on',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_weekly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'cf234242-c687-4084-956a-dd068cea858c', 97074,  current_date , 97074,  current_date , 'lms_count_of_users_coursewise_weekly',
'locationId,roleId,courseId',
'with base_data as(select count(distinct tsa.user_id),date_trunc(''month'',started_on) as started_on from tr_session_analytics tsa
inner join um_user_location uul on tsa.user_id = uul.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
where lesson_id in (select distinct lesson_id from tr_lesson_analytics tla where(#courseId# is null or course_id = #courseId#)	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')) and lhcd.parent_id =#locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by date_trunc(''month'',started_on)),
months as (select
    generate_series(
        current_date - interval ''6'' day,
        current_date, ''1 day''
    ) as week)
select months.week, coalesce(base_data.count,0) as count from months
left join base_data on months.week=base_data.started_on',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_lms_course_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'625a6086-ed54-4a65-a6f8-8209e70a98a0', 58981,  current_date , 58981,  current_date , 'retrieve_lms_course_list',
 null,
'select course_id as "courseId",
course_name as "courseName"
from tr_course_master
where course_state = ''ACTIVE''
and course_type = ''ONLINE''',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_course_completion_rate_by_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7be00e69-9448-4b58-8d76-9790b7994103', 97074,  current_date , 97074,  current_date , 'lms_dashboard_course_completion_rate_by_location',
'course_id,location_id',
'WITH training_ids as (
	select distinct training_id
	from tr_training_course_rel
	WHERE
        (#course_id# IS NULL OR course_id = #course_id#)
        	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
),enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),loc_det AS (
    SELECT child_id AS id
    FROM location_hierchy_closer_det
    WHERE parent_id = #location_id#
        AND depth = 1
),data_list as (
	select distinct um_user.id AS user_id,
	lm.name AS loc_name,
	ltm.name AS loc_type,
	uuld.user_id as app_installed,
	tcwca.course_progress AS course_progress
	FROM location_hierchy_closer_det lhcd
	INNER JOIN loc_det ON loc_det.id = lhcd.parent_id
	INNER JOIN location_master lm ON lm.id = loc_det.id
	INNER JOIN location_type_master ltm ON ltm.type=lm.type
	INNER JOIN um_user_location uul ON lhcd.child_id=uul.loc_id
	INNER JOIN um_user ON um_user.id = uul.user_id
    inner join enrolled_users
		on enrolled_users.enrolled_user_id = um_user.id
	inner join um_user_login_det uuld on uuld.user_id=enrolled_users.enrolled_user_id
	left join tr_course_wise_count_analytics tcwca
	on enrolled_users.enrolled_user_id = tcwca.user_id
	and tcwca.course_id = #course_id#
),completion_rate AS (
select
count(CASE WHEN course_progress = 100 THEN user_id END) AS completed_count,
count(user_id) AS total_count,
count(app_installed) as app_installed,
loc_name AS loc_name,
loc_type AS loc_type
from data_list
GROUP BY loc_name,loc_type
),min_max_percentage AS (
    SELECT
        MIN(completed_count * 100 / total_count) AS min_percentage,
        MAX(completed_count * 100 / total_count) AS max_percentage
    FROM completion_rate
)
SELECT
    completion_rate.completed_count,
--    completion_rate.total_count,
    completion_rate.app_installed as total_count,
    completion_rate.loc_name,
    completion_rate.loc_type,
    CASE
	WHEN completion_rate.completed_count = 0 THEN ''Min''
        WHEN completion_rate.completed_count = completion_rate.total_count THEN ''Max''
	WHEN (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.max_percentage THEN ''Max''
        WHEN (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.min_percentage THEN ''Min''
        ELSE NULL
    END AS count_type
FROM
    completion_rate
INNER JOIN
    min_max_percentage ON (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.min_percentage
    OR (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.max_percentage
ORDER BY
    count_type;',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_modules_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7cafe994-1ce7-44ba-a477-2c3219d18d36', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_modules_by_course_id_v2',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
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
'34a32686-5b34-4d3c-b292-d99db7f4702e', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_lessons_by_course_id_v2',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_learning_hours_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'eef7a9ad-6fc8-47a2-8e1e-cea8948661d0', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_learning_hours_by_course_id_v2',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
)
select tr_course_master.course_id as "courseId",
cast (sum(tr_lesson_analytics.spent_time)  as text) as "timeSpent"
from tr_course_master
left join tr_lesson_analytics on tr_course_master.course_id = tr_lesson_analytics.course_id
 inner join location_user on tr_lesson_analytics.user_id = location_user.user_id
where ( #courseId# is null or tr_course_master.course_id = #courseId#) and tr_course_master.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
group by tr_course_master.course_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_quizzes_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ec9a6b97-cac6-42e7-b00a-d91fe8ee4851', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_quizzes_by_course_id_v2',
'locationId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_course_engagement_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d15d603-e3f6-42e6-a7d2-fd399b896947', 97070,  current_date , 97070,  current_date , 'lms_course_engagement_data',
'locationId,roleId',
'with counts as(select count(distinct tcwca.user_id) filter(where tcwca.course_progress = 100 ) as users, tcwca.course_id,
avg(time_spent_on_course) as time_spent
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id  and uul.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join um_user uu on uu.id = tcwca.user_id and uu.state=''ACTIVE''
where lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id= cast(#roleId# as integer) else true end group by tcwca.course_id),
course_counts as(select counts.*, tcm.course_name from counts
inner join tr_course_master tcm on tcm.course_id=counts.course_id
where tcm.course_state = ''ACTIVE'' and course_type=''ONLINE''),
course_details as(select count(distinct attendee_id)+count(distinct additional_attendee_id) as enrolled_user_id,ttcr.course_id,tcm.course_name
	from tr_training_attendee_rel ttar
	inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
	left join tr_training_additional_attendee_rel ttaar on ttaar.training_id =ttar .training_id
	inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
	inner join um_user_location uul on ttar.attendee_id = uul.user_id  and uul.state=''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id  and uul2.state=''ACTIVE''
	left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id and lhcd2.parent_id = #locationId#	where tcm.course_state = ''ACTIVE'' and tcm.course_type=''ONLINE''
	and lhcd.parent_id = #locationId#
	group by ttcr.course_id ,tcm.course_name
)
select course_details.course_id,course_details.course_name,
(COALESCE(course_counts.users,0)*100)/course_details.enrolled_user_id as completion_rate,
date_part(''minutes'', time_spent) as time_spent
from course_counts
right join course_details on
course_details.course_id=course_counts.course_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71d78981-72af-4625-860d-44c71bb40e9b', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_course_engagement_v2',
'locationId,roleId,courseId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where (#courseId# is null or course_id = #courseId#)
       	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
),
enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
	select distinct user_id
	from location_hierchy_closer_det
		inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		and um_user_location.state=''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where parent_id = #locationId#
),
enrolled_data as (
	select location_users.user_id,
		um_user.role_id as role_id
	from location_users
		inner join um_user on location_users.user_id = um_user.id
		and um_user.state = ''ACTIVE''
),
app_installed as(
	select ed.role_id as role_id,
	count(DISTINCT uuld.user_id) as app_installed
	from enrolled_data ed
	inner join um_user_login_det uuld on uuld.user_id=ed.user_id
	group by ed.role_id
),
roles as (
	select distinct role_id
	from enrolled_data
),
enrolled as (
	select enrolled_data.role_id as role_id,
		count(1) as enrolled
	from enrolled_data
	group by enrolled_data.role_id
),
course_status as (
	select enrolled_data.role_id as role_id,
		count(1) filter (
			where (
					course_progress is null
					or course_progress between 1 and 99
				)
		) as in_progress,
		count(1) filter (
			where course_progress = 100
		) as completed
	from enrolled_data
		inner join tr_course_wise_count_analytics on enrolled_data.user_id = tr_course_wise_count_analytics.user_id
		and (#courseId# is null or tr_course_wise_count_analytics.course_id = #courseId#)
	group by enrolled_data.role_id
),
not_started as (
	select enrolled_data.role_id,
		count(1) filter (
			where tr_user_meta_data.user_id is null
			and tr_user_meta_data.user_id in (select uuld.user_id
	from enrolled_data ed
	inner join um_user_login_det uuld on uuld.user_id=ed.user_id)
		) as not_started
	from enrolled_data
		left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
		and (#courseId# is null or tr_user_meta_data.course_id = #courseId#)
	group by enrolled_data.role_id
)
select um_role_master.id as "roleId",
	um_role_master.name as "roleName",
	coalesce(enrolled.enrolled, 0) as "enrolled",
	coalesce(not_started.not_started, 0) as "notStarted",
	coalesce(course_status.in_progress, 0) as "inProgress",
	coalesce(course_status.completed, 0) as "completed",
	coalesce(app_installed.app_installed,0) as "appInstalled"
from roles
	left join enrolled on roles.role_id = enrolled.role_id
	left join course_status on roles.role_id = course_status.role_id
	left join not_started on roles.role_id = not_started.role_id
	left join app_installed on roles.role_id = app_installed.role_id
	inner join um_role_master on roles.role_id = um_role_master.id
	and um_role_master.state = ''ACTIVE''
where case
		when #roleId# is not null then roles.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_top_scorers_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b5b5b9a8-123a-41a3-9838-28b800318a92', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_top_scorers_v2',
'locationId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_completors_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7817d22e-60a7-4eec-b080-c792f05c7ea4', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_course_completors_v2',
'locationId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
), course_completion as (
	select tr_lesson_analytics.user_id as user_id,
	sum(spent_time) as spent_time,
	min(tr_lesson_analytics.started_on) as course_started_on,
	max(tr_lesson_analytics.ended_on) as course_ended_on
	from tr_lesson_analytics
    inner join location_user on location_user.user_id=tr_lesson_analytics.user_id
	inner join tr_user_meta_data on tr_lesson_analytics.user_id = tr_user_meta_data.user_id
	and tr_lesson_analytics.course_id = tr_user_meta_data.course_id
	where (#courseId# is null or tr_lesson_analytics.course_id = #courseId#) and tr_lesson_analytics.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
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
		 else concat(ROUND(extract(second from spent_time),2),'' sec'')
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
		 else concat(Round(extract(second from (course_ended_on - course_started_on)),2),'' sec'')
		 end
) as "finishedIn"
from course_completion
inner join um_user on course_completion.user_id = um_user.id
and um_user.state = ''ACTIVE''
order by (course_ended_on - course_started_on);',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_users_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ea37fd8f-cbba-443d-ac6a-49fc4d4256ef', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_users_v2',
'locationId',
'select count(distinct uu.id) as "totalUsers",
	count(distinct uuld.user_id) as "appInstalled"
from location_hierchy_closer_det lhcd
	inner join um_user_location uul on uul.loc_id = lhcd.child_id
	and uul.state = ''ACTIVE''
	inner join um_user uu on uu.id = uul.user_id
	and uu.state = ''ACTIVE''
	left join um_user_login_det uuld on uuld.user_id = uu.id
where lhcd.parent_id = #locationId# and uu.role_id = (select id from um_role_master where name=''ANM'')',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_learning_app_usage_active_users';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'125e16e7-d675-498c-9118-d9769b8ee8df', 97074,  current_date , 97074,  current_date , 'lms_dashboard_learning_app_usage_active_users',
'locationId,roleId,courseId',
'select count(distinct tcwca.user_id) as total,count(distinct tcwca.user_id) filter (where course_progress = 100) as "100%completed",
count(distinct tcwca.user_id) filter (where course_progress < 100 and course_progress >=75 ) as "75%completed",
count(distinct tcwca.user_id) filter (where course_progress < 75 and course_progress >=50 ) as "50%completed",
count(distinct tcwca.user_id) filter (where course_progress < 50 and course_progress >=25 ) as "25%complete",
count(distinct tcwca.user_id) filter (where course_progress between 1 and 24) as "lessthan25%completed" from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id and uul.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
where (#courseId# is null or course_id = #courseId#) and lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97074,  current_date , 97074,  current_date , 'lms_heatmap_data',
'roleId,courseId',
'with location_ids as(
select child_id from location_hierchy_closer_det where parent_id = 555800 and depth = 1
),
user_count as(select
count (distinct tcwca.user_id),lhcd.parent_id
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on uul.user_id=tcwca.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join location_ids lid on lid.child_id=lhcd.parent_id
where (#courseId# is null or course_id=#courseId#) 	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'') and course_progress=100
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by lhcd.parent_id),
total_count as (select count(distinct attendee_id)+count(distinct additional_attendee_id) as enrolled_user_id,ttcr.course_id,lid.child_id
	from tr_training_attendee_rel ttar
	inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
	left join tr_training_additional_attendee_rel ttaar on ttaar.training_id =ttar .training_id
	inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
	inner join um_user_location uul on ttar.attendee_id = uul.user_id and uul.state=''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id and uul2.state=''ACTIVE''
	left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id
	inner join location_ids lid on lid.child_id=lhcd.parent_id or lid.child_id=lhcd2.parent_id
	where (#courseId# is null or ttcr.course_id=#courseId#) and ttcr.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
	group by ttcr.course_id,lid.child_id),
analytics as(select
("count"*100)/enrolled_user_id as series_label,
lm.id,lm.english_name as x_axis_label
from total_count
left join user_count on total_count.child_id=user_count.parent_id
inner join location_master lm on lm.id=total_count.child_id)
select x_axis_label,series_label,
case
when series_label between 85 and 100 then ''#1e621e''
when series_label between 50 and 84 then ''#ffcc00''
when series_label between 25 and 49 then ''#ff751a''
when series_label between 0 and 24 then ''#ff0000''
end as color
from analytics',
null,
true, 'ACTIVE');