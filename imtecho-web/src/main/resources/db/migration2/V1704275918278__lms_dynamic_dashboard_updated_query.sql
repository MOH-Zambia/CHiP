DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_district_performance_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'23fc04c3-28de-45b4-9f48-42dbf9109770', 97070,  current_date , 97070,  current_date , 'lms_retrieve_district_performance_data',
'locationId,loggedInUserId,courseId',
'with locations as(
	select DISTINCT child_id
	from location_hierchy_closer_det
	where (
			case
				when #locationId# is null then parent_id in (
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
				and depth = 1
			),
			counts as(
				select count(distinct tcwca.user_id) filter(
						where tcwca.course_progress = 100
					) as users,
					locations.child_id
				from locations
					inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
					inner join um_user_location uul on uul.loc_id = lhcd.child_id
					and uul.state = ''ACTIVE''
					inner join um_user uu on uu.id = uul.user_id
					and uu.state = ''ACTIVE''
					left join tr_course_wise_count_analytics tcwca on uu.id = tcwca.user_id
				where (
						case
							when #courseId# is not null then tcwca.course_id = #courseId# else true end)
							group by locations.child_id
						),
						course_details as(
							select count(distinct attendee_id) + count(distinct additional_attendee_id) filter(
									where ttaar is not null
								) as enrolled_user_id,
								locations.child_id
							from locations
								inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
								inner join um_user_location uul on uul.loc_id = lhcd.child_id
								and uul.state = ''ACTIVE''
								inner join um_user uu on uu.id = uul.user_id
								and uu.state = ''ACTIVE''
								inner join um_user_login_det uuld on uuld.user_id = uu.id
								inner join tr_training_attendee_rel ttar on uu.id = ttar.attendee_id
								inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
								and (
									case
										when #courseId# is not null then ttcr.course_id = #courseId# else true end)
										left join tr_training_additional_attendee_rel ttaar on ttaar.additional_attendee_id = uu.id
										and ttcr.training_id = ttaar.training_id
										group by locations.child_id
									)
									select lm.name,
										COALESCE(
											(COALESCE(counts.users, 0) * 100) / course_details.enrolled_user_id,
											0
										) as completion_rate
									from course_details
									left join locations on course_details.child_id = locations.child_id
										left join location_master lm on lm.id = locations.child_id
										left join counts on counts.child_id = locations.child_id',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_all_course_overview_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'59c10ad3-a2f2-45c6-9d32-6b8a09a69d2d', 97070,  current_date , 97070,  current_date , 'lms_retrieve_all_course_overview_data',
'locationId,loggedInUserId',
'with training_ids as (
    select distinct training_id,
        course_id
    from tr_training_course_rel
    where course_id in (
            select course_id
            from tr_course_master
            where course_state = ''ACTIVE''
                and course_type = ''ONLINE''
        )
),
enrolled_users as (
    select distinct attendee_id as enrolled_user_id,
        course_id
    from tr_training_attendee_rel
        inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
    union
    select distinct additional_attendee_id as enrolled_user_id,
        course_id
    from tr_training_additional_attendee_rel
        inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
    select distinct user_id,
        course_id
    from location_hierchy_closer_det
        inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
        and um_user_location.state = ''ACTIVE''
        inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
    where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (
                #locationId#) end)
            ),
            enrolled_data as (
                select distinct location_users.user_id,
                    course_id
                from location_users
                    inner join um_user on location_users.user_id = um_user.id
                    and um_user.state = ''ACTIVE''
            ),
            app_installed as(
                select ed.course_id as course_id,
                    count(DISTINCT uuld.user_id) as app_installed
                from enrolled_data ed
                    inner join um_user_login_det uuld on uuld.user_id = ed.user_id
                group by ed.course_id
            ),
            course_status as (
                select enrolled_data.course_id as course_id,
                    count(distinct tr_course_wise_count_analytics.user_id) filter (
                        where course_progress = 100
                    ) as completed
                from enrolled_data
                    inner join tr_course_wise_count_analytics on enrolled_data.user_id = tr_course_wise_count_analytics.user_id
                    and enrolled_data.course_id = tr_course_wise_count_analytics.course_id
                    and tr_course_wise_count_analytics.course_id in (
                        select course_id
                        from tr_course_master
                        where course_state = ''ACTIVE''
                            and course_type = ''ONLINE''
                    )
                group by enrolled_data.course_id
            ),
            courses as (
                select distinct course_id
                from enrolled_data
            )
            select tr_course_master.course_id as course_id,
                tr_course_master.course_name as course_name,
                case
                    when app_installed.app_installed = 0 then 0
                    else (
                        coalesce(course_status.completed,0) * 100 / app_installed.app_installed                    )
                end as completion_rate
            from courses
                left join course_status on courses.course_id = course_status.course_id
                left join app_installed on courses.course_id = app_installed.course_id
                inner join tr_course_master on courses.course_id = tr_course_master.course_id',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_quizzes_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ec9a6b97-cac6-42e7-b00a-d91fe8ee4851', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_quizzes_by_course_id_v2',
'locationId,loggedInUserId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where (
			case
				when #locationId# is null then parent_id in (
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
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

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_lessons_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'34a32686-5b34-4d3c-b292-d99db7f4702e', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_lessons_by_course_id_v2',
'locationId,loggedInUserId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where (
			case
				when #locationId# is null then parent_id in (
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
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

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_modules_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7cafe994-1ce7-44ba-a477-2c3219d18d36', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_modules_by_course_id_v2',
'locationId,loggedInUserId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where (
			case
				when #locationId# is null then parent_id in (
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
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

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_completors_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7817d22e-60a7-4eec-b080-c792f05c7ea4', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_course_completors_v2',
'locationId,loggedInUserId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (
                #locationId#) end)
            ),
            course_completion as (
                select tr_lesson_analytics.user_id as user_id,
                    sum(spent_time) as spent_time,
                    min(tr_lesson_analytics.started_on) as course_started_on,
                    max(tr_lesson_analytics.ended_on) as course_ended_on
                from tr_lesson_analytics
                    inner join location_user on location_user.user_id = tr_lesson_analytics.user_id
                    inner join tr_user_meta_data on tr_lesson_analytics.user_id = tr_user_meta_data.user_id
                    and tr_lesson_analytics.course_id = tr_user_meta_data.course_id
                where (
                        case
                            when #courseId# is not null then tr_lesson_analytics.course_id = #courseId# else true end)
                            and tr_user_meta_data.is_course_completed
                            group by tr_lesson_analytics.user_id
                        )
                        select um_user.id as "userId",
                            concat_ws(
                                '' '',
                                um_user.first_name,
                                um_user.middle_name,
                                um_user.last_name
                            ) as "userName",
                            concat(
                                case
                                    when (
                                        extract(
                                            day
                                            from spent_time
                                        ) * 24 + extract(
                                            hour
                                            from spent_time
                                        )
                                    ) <= 0 then ''''
                                    else concat(
                                        extract(
                                            day
                                            from spent_time
                                        ) * 24 + extract(
                                            hour
                                            from spent_time
                                        ),
                                        '' hr ''
                                    )
                                end,
                                case
                                    when extract(
                                        minute
                                        from spent_time
                                    ) <= 0 then ''''
                                    else concat(
                                        extract(
                                            minute
                                            from spent_time
                                        ),
                                        '' min ''
                                    )
                                end,
                                case
                                    when extract(
                                        second
                                        from spent_time
                                    ) <= 0 then ''''
                                    else concat(
                                        CAST(
                                            extract(
                                                second
                                                from spent_time
                                            ) as numeric(10, 2)
                                        ),
                                        '' sec''
                                    )
                                end
                            ) as "spentTime",
                            concat(
                                case
                                    when (
                                        extract(
                                            day
                                            from (course_ended_on - course_started_on)
                                        ) * 24 + extract(
                                            hour
                                            from (course_ended_on - course_started_on)
                                        )
                                    ) <= 0 then ''''
                                    else concat(
                                        extract(
                                            day
                                            from (course_ended_on - course_started_on)
                                        ) * 24 + extract(
                                            hour
                                            from (course_ended_on - course_started_on)
                                        ),
                                        '' hr ''
                                    )
                                end,
                                case
                                    when extract(
                                        minute
                                        from (course_ended_on - course_started_on)
                                    ) <= 0 then ''''
                                    else concat(
                                        extract(
                                            minute
                                            from (course_ended_on - course_started_on)
                                        ),
                                        '' min ''
                                    )
                                end,
                                case
                                    when extract(
                                        second
                                        from (course_ended_on - course_started_on)
                                    ) <= 0 then ''''
                                    else concat(
                                        cast(
                                            extract(
                                                second
                                                from (course_ended_on - course_started_on)
                                            ) as numeric(10, 2)
                                        ),
                                        '' sec''
                                    )
                                end
                            ) as "finishedIn"
                        from course_completion
                            inner join um_user on course_completion.user_id = um_user.id
                            and um_user.state = ''ACTIVE''
                        order by (course_ended_on - course_started_on);',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_top_scorers_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b5b5b9a8-123a-41a3-9838-28b800318a92', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_top_scorers_v2',
'locationId,loggedInUserId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (
                #locationId#) end)
            ),
            practice_quizzes as (
                select course_id,
                    cast(quiz_config.key as integer) as question_set_type,
                    cast(
                        quiz_config.value->>''doYouWantAQuizToBeMarked'' as boolean
                    ) as is_quiz
                from tr_course_master,
                    jsonb_each(cast(tr_course_master.test_config_json as jsonb)) as quiz_config
                where (
                        #courseId# is null or tr_course_master.course_id = #courseId#) and tr_course_master.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
                        and course_type = ''ONLINE''
                    )
            ),
            marks as (
                select tr_question_set_configuration.ref_id,
                    tr_question_set_configuration.ref_type,
                    tr_question_set_configuration.question_set_type,
                    tr_question_set_answer.user_id,
                    coalesce(
                        tr_question_set_answer.marks_scored * 100 / tr_question_set_configuration.total_marks,
                        0
                    ) as per_scored
                from tr_question_set_answer
                    inner join tr_question_set_configuration on tr_question_set_answer.question_set_id = tr_question_set_configuration.id
                    inner join practice_quizzes on tr_question_set_configuration.question_set_type = practice_quizzes.question_set_type
                    and practice_quizzes.is_quiz
                where (
                        #courseId# is null or tr_question_set_configuration.course_id = #courseId#)
                        and tr_question_set_configuration.status = ''ACTIVE''
                    )
                select um_user.id as "userId",
                    concat_ws(
                        '' '',
                        um_user.first_name,
                        um_user.middle_name,
                        um_user.last_name
                    ) as "userName",
                    coalesce(cast(avg(per_scored) as integer), 0) as score
                from marks
                    inner join location_user on location_user.user_id = marks.user_id
                    inner join um_user on marks.user_id = um_user.id
                    and um_user.state = ''ACTIVE''
                group by um_user.id
                order by score desc',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_monthly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0409f66b-1a17-49f2-b8d9-d553fea8ab2e', 97070,  current_date , 97070,  current_date , 'lms_count_of_users_coursewise_monthly',
'locationId,roleId,loggedInUserId,courseId',
'with base_data as(
	select count(distinct tsa.user_id),
		date_trunc(''month'', started_on) as started_on
	from tr_session_analytics tsa
		inner join um_user_location uul on tsa.user_id = uul.user_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
	where lesson_id in (
			select distinct lesson_id
			from tr_lesson_analytics tla
			where (
					#courseId# is null or course_id = #courseId#)	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
					and course_type = ''ONLINE''
				)
		)
		and (
			case
				when #locationId# is null then parent_id in (
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
				and case
					when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
					group by date_trunc(''month'', started_on)
				),
				months as (
					select generate_series(
							date_trunc(''month'', current_date - interval ''11'' month),
							current_date,
							''1 month''
						) as month
				)
				select months.month,
					coalesce(base_data.count, 0) as count
				from months
					left join base_data on months.month = base_data.started_on',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_weekly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'cf234242-c687-4084-956a-dd068cea858c', 97070,  current_date , 97070,  current_date , 'lms_count_of_users_coursewise_weekly',
'locationId,roleId,loggedInUserId,courseId',
'with base_data as(
    select count(distinct tsa.user_id),
        date_trunc(''month'', started_on) as started_on
    from tr_session_analytics tsa
        inner join um_user_location uul on tsa.user_id = uul.user_id
        and uul.state = ''ACTIVE''
        inner join um_user uu on uu.id = uul.user_id
        and uu.state = ''ACTIVE''
        inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
    where lesson_id in (
            select distinct lesson_id
            from tr_lesson_analytics tla
            where(
                    #courseId# is null or course_id = #courseId#)	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
                    and course_type = ''ONLINE''
                )
        )
        and (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (#locationId#) end)
                and case
                    when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
                    group by date_trunc(''month'', started_on)
                ),
                months as (
                    select generate_series(
                            current_date - interval ''6'' day,
                            current_date,
                            ''1 day''
                        ) as week
                )
                select months.week,
                    coalesce(base_data.count, 0) as count
                from months
                    left join base_data on months.week = base_data.started_on',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_learning_usage_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'57c070d9-34fd-4c4c-a266-76c461383094', 97070,  current_date , 97070,  current_date , 'lms_retrieve_learning_usage_data',
'locationId,loggedInUserId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
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
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (#locationId#) end)
),
enrolled_data as (
	select distinct location_users.user_id
	from location_users
		inner join um_user on location_users.user_id = um_user.id
		and um_user.state = ''ACTIVE''
),
app_installed as(
	select count(DISTINCT uuld.user_id) as app_installed
	from enrolled_data ed
		inner join um_user_login_det uuld on uuld.user_id = ed.user_id
),
enrolled as (
	select count(1) as enrolled
	from enrolled_data
),
course_analytics as(
	select user_id,
		round(avg(course_progress), 2) as course_progress
	from tr_course_wise_count_analytics
	group by user_id
),
course_status as (
	select count(1) filter (
			where (
					course_progress is null
					or course_progress between 1 and 99
				)
		) as in_progress,
		count(1) filter (
			where course_progress = 100
		) as completed,
		count(course_analytics.user_id) filter (
			where course_progress < 100
				and course_progress > 75
		) as completed_75,
		count(course_analytics.user_id) filter (
			where course_progress <= 75
				and course_progress > 50
		) as completed_50,
		count(course_analytics.user_id) filter (
			where course_progress <= 50
				and course_progress > 25
		) as completed_25,
		count(course_analytics.user_id) filter (
			where course_progress between 1 and 25
		) as less_than_25
	from enrolled_data
		inner join course_analytics on enrolled_data.user_id = course_analytics.user_id
),
not_started as (
	select count(distinct enrolled_data.user_id) filter (where course_analytics.course_progress = 0 or tr_user_meta_data.user_id is null) as not_started
	from enrolled_data
		left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
		left join course_analytics on enrolled_data.user_id = course_analytics.user_id
)
select coalesce(enrolled.enrolled, 0) as "enrolled",
	coalesce(not_started.not_started, 0) as "notStarted",
	coalesce(course_status.in_progress, 0) as "inProgress",
	coalesce(course_status.completed, 0) as "completed",
	coalesce(app_installed.app_installed, 0) as "appInstalled",
	coalesce(course_status.completed_75, 0) as "completed75",
	coalesce(course_status.completed_50, 0) as "completed50",
	coalesce(course_status.completed_25, 0) as "completed25",
	coalesce(course_status.less_than_25, 0) as "lessthan25completed"
from enrolled,
	course_status,
	not_started,
	app_installed',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_course_wise_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8dd2db01-a64c-4e0d-aaab-3fa18211f335', 97070,  current_date , 97070,  current_date , 'lms_retrieve_course_wise_data',
'locationId,loggedInUserId',
'with training_ids as (
	select distinct training_id,
		course_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
),
enrolled_users as (
	select distinct attendee_id as enrolled_user_id,
		course_id
	from tr_training_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id,
		course_id
	from tr_training_additional_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
	select distinct user_id,
		course_id
	from location_hierchy_closer_det
		inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (#locationId#) end)
			),
			enrolled_data as (
				select distinct location_users.user_id,
					course_id
				from location_users
					inner join um_user on location_users.user_id = um_user.id
					and um_user.state = ''ACTIVE''
			),
			app_installed as(
				select ed.course_id as course_id,
					count(DISTINCT uuld.user_id) as app_installed
				from enrolled_data ed
					inner join um_user_login_det uuld on uuld.user_id = ed.user_id
				group by ed.course_id
			),
			enrolled as (
				select enrolled_data.course_id as course_id,
					count(1) as enrolled
				from enrolled_data
				group by enrolled_data.course_id
			),
			course_status as (
				select enrolled_data.course_id as course_id,
					count(1) filter (
						where (
								course_progress is null
								or course_progress between 0 and 99
							)
					) as in_progress,
					count(1) filter (
						where course_progress = 100
					) as completed,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress < 100
							and course_progress > 75
					) as completed_75,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress <= 75
							and course_progress > 50
					) as completed_50,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress <= 50
							and course_progress > 25
					) as completed_25,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress between 1 and 25
					) as less_than_25
				from enrolled_data
					inner join tr_course_wise_count_analytics on enrolled_data.user_id = tr_course_wise_count_analytics.user_id
					and enrolled_data.course_id = tr_course_wise_count_analytics.course_id
					and tr_course_wise_count_analytics.course_id in (
						select course_id
						from tr_course_master
						where course_state = ''ACTIVE''
							and course_type = ''ONLINE''
					)
				group by enrolled_data.course_id
			),
			not_started as (
				select enrolled_data.course_id,
					count(distinct enrolled_data.user_id) filter (
						where tr_user_meta_data.user_id is null or tr_course_wise_count_analytics.course_progress = 0
					) as not_started
				from enrolled_data
					left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
					and enrolled_data.course_id = tr_user_meta_data.course_id
					and tr_user_meta_data.course_id in (
						select course_id
						from tr_course_master
						where course_state = ''ACTIVE''
							and course_type = ''ONLINE''
					)
					inner join um_user_login_det uuld on uuld.user_id = enrolled_data.user_id
					left join tr_course_wise_count_analytics on enrolled_data.user_id = tr_course_wise_count_analytics.user_id
				group by enrolled_data.course_id
			),
			courses as (
				select distinct course_id
				from enrolled_data
			)
			select tr_course_master.course_id as "courseId",
				tr_course_master.course_name as "courseName",
				coalesce(enrolled.enrolled, 0) as "enrolled",
				coalesce(not_started.not_started, 0) as "notStarted",
				coalesce(course_status.in_progress, 0) as "inProgress",
				coalesce(course_status.completed, 0) as "completed",
				coalesce(app_installed.app_installed, 0) as "appInstalled",
				coalesce(course_status.completed_75, 0) as "75complete",
				coalesce(course_status.completed_50, 0) as "50complete",
				coalesce(course_status.completed_25, 0) as "25complete",
				coalesce(course_status.less_than_25, 0) as "lessthan25completed"
			from courses
				left join enrolled on courses.course_id = enrolled.course_id
				left join course_status on courses.course_id = course_status.course_id
				left join not_started on courses.course_id = not_started.course_id
				left join app_installed on courses.course_id = app_installed.course_id
				inner join tr_course_master on courses.course_id = tr_course_master.course_id',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_user_statistics_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ce0cf00b-7401-47cf-9868-a47fef771ae6', 97070,  current_date , 97070,  current_date , 'lms_retrieve_user_statistics_data',
'locationId,loggedInUserId',
'with training_ids as (
    select distinct training_id
    from tr_training_course_rel
    where course_id in (
            select course_id
            from tr_course_master
            where course_state = ''ACTIVE''
                and course_type = ''ONLINE''
        )
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
        and um_user_location.state = ''ACTIVE''
        inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
    where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (#locationId#) end)
),
enrolled_data as (
    select distinct location_users.user_id
    from location_users
        inner join um_user on location_users.user_id = um_user.id
        and um_user.state = ''ACTIVE''
),
from_series as (
    select cast(
            generate_series(
                date_trunc(''month'', current_date - interval ''11'' month),
                current_date,
                ''1 month''
            ) as date
        ) as from_month
),
months as (
    select cast(
            date_trunc(''month'', from_month) + interval ''1 month'' - interval ''1 day'' as date
        ) as month
    from from_series
),
active_users as(
    select count(distinct enrolled_data.user_id) filter(
            where cast(tsa.started_on as date) <= months.month
                and tsa is not null
        ),
        date_trunc(''month'', months.month) as started_on
    from enrolled_data
        cross join months
        inner join um_user uu on enrolled_data.user_id = uu.id
        and uu.state = ''ACTIVE''
        inner join (
            select min(started_on) as started_on,
                user_id
            from tr_session_analytics
            group by user_id
        ) as tsa on tsa.user_id = enrolled_data.user_id
    group by date_trunc(''month'', months.month)
),
appinstalled_users as(
    select count(distinct enrolled_data.user_id) filter(
            where cast(uuld.created_on as date) <= months.month
                and uuld is not null
        ),
        date_trunc(''month'', months.month) as created_on
    from enrolled_data
        cross join months
        inner join um_user uu on enrolled_data.user_id = uu.id
        and uu.state = ''ACTIVE''
        inner join (
            select min(created_on) as created_on,
                user_id
            from um_user_login_det
            group by user_id
        ) as uuld on enrolled_data.user_id = uuld.user_id
    group by date_trunc(''month'', months.month)
),
final_users as(
    select count(DISTINCT enrolled_data.user_id)
    from enrolled_data
        inner join um_user uu on enrolled_data.user_id = uu.id
        and uu.state = ''ACTIVE''
)
select to_char(months.month, ''mm/yy'') as month,
    coalesce(active_users.count, 0) as "totalActiveUsers",
    coalesce(appinstalled_users.count, 0) as "totalAppInstalled",
    coalesce(final_users.count, 0) as "totalEnrolled"
from months
    cross join final_users
    left join active_users on date_trunc(''month'', months.month) = date_trunc(''month'', active_users.started_on)
    left join appinstalled_users on date_trunc(''month'', months.month) = date_trunc(''month'', appinstalled_users.created_on)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_header_data_for_total_users';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'17cefd02-43d6-42bc-abaf-482758fe5544', 97070,  current_date , 97070,  current_date , 'lms_header_data_for_total_users',
'locationId,loggedInUserId',
'with training_ids as (
    select distinct training_id
    from tr_training_course_rel
    where course_id in (
            select course_id
            from tr_course_master
            where course_state = ''ACTIVE''
                and course_type = ''ONLINE''
        )
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
        and um_user_location.state = ''ACTIVE''
        inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
    where (
            case
                when #locationId# is null then parent_id in (
                select loc_id
                from um_user_location
                where state = ''ACTIVE''
                    and user_id = #loggedInUserId#
            )
            else parent_id in (#locationId#) end)
        ),
        enrolled_data as (
            select distinct location_users.user_id
            from location_users
                inner join um_user on location_users.user_id = um_user.id
                and um_user.state = ''ACTIVE''
        )
    select count(DISTINCT enrolled_data.user_id) as "totalEnrolled",
        count(DISTINCT enrolled_data.user_id) filter(
            where uuld.id is not null
        ) as "totalAppInstalled",
        count(DISTINCT enrolled_data.user_id) filter(
            where tsa.user_id is not null
        ) as "totalActiveUsers"
    from enrolled_data
        inner join um_user uu on enrolled_data.user_id = uu.id
        left join um_user_login_det uuld on enrolled_data.user_id = uuld.user_id
        left join tr_session_analytics tsa on tsa.user_id = enrolled_data.user_id
    where uu.state = ''ACTIVE''',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_lms_course_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'625a6086-ed54-4a65-a6f8-8209e70a98a0', 97070,  current_date , 97070,  current_date , 'retrieve_lms_course_list',
'parentIds',
'select distinct tcm.course_id as "courseId",
    tcm.course_name as "courseName"
from tr_course_master tcm
    inner join tr_training_course_rel ttcr on ttcr.course_id = tcm.course_id
    inner join tr_training_org_unit_rel ttour on ttour.training_id = ttcr.training_id
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = ttour.org_unit_id
    and lhcd.parent_id in (#parentIds#)
where tcm.course_state = ''ACTIVE''
    and tcm.course_type = ''ONLINE''',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_user_assigned_location_by_user_id_and_location_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'001fcd75-bafe-4b80-871f-3a007717224f', 97070,  current_date , 97070,  current_date , 'retrieve_user_assigned_location_by_user_id_and_location_type',
'level,userId',
'select lm.* from um_user_location uul
inner join location_master lm on uul.loc_id = lm.id
and uul.user_id = #userId# and uul.state=''ACTIVE'' and lm.type in (select type from location_type_master where level=#level#)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97070,  current_date , 97070,  current_date , 'lms_heatmap_data',
 null,
'with location_ids as(
	select child_id
	from location_hierchy_closer_det
	where parent_id in (
			select id
			from location_master
			where type = ''S''
		)
		and depth = 1
),
user_count as(
	select count (distinct tcwca.user_id),
		lhcd.parent_id
	from tr_course_wise_count_analytics tcwca
		inner join um_user_location uul on uul.user_id = tcwca.user_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
		inner join location_ids lid on lid.child_id = lhcd.parent_id
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
		and course_progress = 100
	group by lhcd.parent_id
),
total_count as (
	select count(distinct attendee_id) + count(distinct additional_attendee_id) as enrolled_user_id,
		locations.child_id
	from location_ids as locations
		inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
		inner join um_user_location uul on uul.loc_id = lhcd.child_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join um_user_login_det uuld on uuld.user_id = uu.id
		inner join tr_training_attendee_rel ttar on uu.id = ttar.attendee_id
		inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
		left join tr_training_additional_attendee_rel ttaar on ttaar.additional_attendee_id = uu.id
		and ttcr.training_id = ttaar.training_id
	group by locations.child_id
),
analytics as(
	select ("count" * 100) / enrolled_user_id as series_label,
		lm.id,
		lm.english_name as x_axis_label
	from total_count
		left join user_count on total_count.child_id = user_count.parent_id
		inner join location_master lm on lm.id = total_count.child_id
)
select x_axis_label,
	series_label,
	case
		when series_label = 100 then ''#006600''
		when series_label between 76 and 99 then ''#3399ff''
		when series_label between 51 and 75 then ''#ffbb00''
		when series_label between 26 and 50 then ''#ff6600''
		when series_label between 1 and 25 then ''#cc0000''
	end as color
from analytics',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_app_installed_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7462b6ee-b4f6-456e-b426-48a4cf232171', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_app_installed_members',
'offset,locationId,limit,loggedInUserId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
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
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
        case
            when #locationId# is null then parent_id in (
            select loc_id
            from um_user_location
            where state = ''ACTIVE''
                and user_id = #loggedInUserId#
        )
        else parent_id in (#locationId#) end)
		),
		enrolled_data as (
			select distinct location_users.user_id
			from location_users
				inner join um_user on location_users.user_id = um_user.id
				and um_user.state = ''ACTIVE''
		),
district_name as (
	select lm.name as "district", enrolled_users.enrolled_user_id
	from enrolled_users
	inner join um_user_location uul on uul.user_id = enrolled_users.enrolled_user_id
	and uul.state = ''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	and lhcd.parent_loc_type = ''D''
	inner join location_master lm on lhcd.parent_id = lm.id
)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		district_name.district as "district",
		(
			case
				when uuld is not null then ''Yes''
				else ''No''
			end
		) as "appInstalled"
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		inner join um_user_login_det uuld on enrolled_data.user_id = uuld.user_id
		inner join district_name on district_name.enrolled_user_id = enrolled_data.user_id
	where uu.state = ''ACTIVE''
	limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_active_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'90be42e5-24e5-4a84-b407-c127ccbba97a', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_active_members',
'offset,locationId,limit,loggedInUserId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
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
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
        case
            when #locationId# is null then parent_id in (
            select loc_id
            from um_user_location
            where state = ''ACTIVE''
                and user_id = #loggedInUserId#
        )
        else parent_id in (#locationId#) end)
		),
enrolled_data as (
	select distinct location_users.user_id
	from location_users
		inner join um_user on location_users.user_id = um_user.id
		and um_user.state = ''ACTIVE''
),
course_status as (
	select distinct location_users.user_id as enrolled_user_id,
		tr_user_meta_data.user_id as user_id,
		tr_user_meta_data.is_course_completed
	from location_users
		left join tr_user_meta_data on location_users.user_id = tr_user_meta_data.user_id
		and tr_user_meta_data.course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
),
course_time as (
	select distinct user_id,
		min(started_on) as course_started_on,
		max(ended_on) as course_ended_on
	from tr_lesson_analytics
	where
		course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
	group by user_id
),
lession_time as (
	select distinct user_id,
		sum(time_to_complete_lesson) as total_spent_time_on_lession,
		count(time_to_complete_lesson) as total_lession
	from tr_lesson_analytics
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
	group by user_id
),
district_name as (
	select lm.name as "district", enrolled_users.enrolled_user_id
	from enrolled_users
	inner join um_user_location uul on uul.user_id = enrolled_users.enrolled_user_id
	and uul.state = ''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	and lhcd.parent_loc_type = ''D''
	inner join location_master lm on lhcd.parent_id = lm.id
)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		district_name.district as "district"

		from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		inner join tr_session_analytics tsa on tsa.user_id = enrolled_data.user_id
		inner join district_name on district_name.enrolled_user_id = enrolled_data.user_id

	where uu.state = ''ACTIVE''
limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_registered_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c0cb39e2-dbfe-43d5-9302-61d616e39bad', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_registered_members',
'offset,locationId,limit,loggedInUserId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
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
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
        case
            when #locationId# is null then parent_id in (
            select loc_id
            from um_user_location
            where state = ''ACTIVE''
                and user_id = #loggedInUserId#
        )
        else parent_id in (#locationId#) end)
		),
enrolled_data as (
	select distinct location_users.user_id
	from location_users
		inner join um_user on location_users.user_id = um_user.id
		and um_user.state = ''ACTIVE''
),
district_name as (
	select lm.name as "district", enrolled_users.enrolled_user_id
	from enrolled_users
	inner join um_user_location uul on uul.user_id = enrolled_users.enrolled_user_id
	and uul.state = ''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	and lhcd.parent_loc_type = ''D''
	inner join location_master lm on lhcd.parent_id = lm.id
)
select DISTINCT uu.id,
	concat(uu.first_name, '' '', uu.last_name) as "participantName",
	uu.user_name as "userName",
	urm.name as "roleName",
	district_name.district as "district",
	(
		case
			when uuld is not null then ''Yes''
			else ''No''
		end
	) as "appInstalled"
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		left join um_user_login_det uuld on enrolled_data.user_id = uuld.user_id
		inner join district_name on district_name.enrolled_user_id = enrolled_data.user_id
	where uu.state = ''ACTIVE''
	limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_child_locations_by_type_and_user_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3a61e766-b29c-4252-8459-eab2f24a0890', 97157,  current_date , 97157,  current_date , 'retrieve_child_locations_by_type_and_user_id',
'locationId',
'select * from location_master where parent in (#locationId#)',
null,
true, 'ACTIVE');