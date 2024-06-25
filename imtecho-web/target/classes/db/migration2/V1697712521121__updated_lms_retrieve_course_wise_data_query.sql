DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_course_wise_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8dd2db01-a64c-4e0d-aaab-3fa18211f335', 97070,  current_date , 97070,  current_date , 'lms_retrieve_course_wise_data',
'locationId',
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
				when #locationId# is not null then parent_id = #locationId# else true end)
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
								or course_progress between 1 and 99
							)
					) as in_progress,
					count(1) filter (
						where course_progress = 100
					) as completed,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress < 100
							and course_progress >= 75
					) as completed_75,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress < 75
							and course_progress >= 50
					) as completed_50,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress < 50
							and course_progress >= 25
					) as completed_25,
					count(tr_course_wise_count_analytics.user_id) filter (
						where course_progress between 0 and 24
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
						where tr_user_meta_data.user_id is null
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