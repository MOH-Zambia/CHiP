DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_user_statistics_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'ce0cf00b-7401-47cf-9868-a47fef771ae6', 97070,  current_date , 97070,  current_date , 'lms_retrieve_user_statistics_data',
 null,
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
    where parent_id in (
            select id
            from location_master
            where type = ''S''
        )
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

DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97070,  current_date , 97070,  current_date , 'lms_heatmap_data',
 null,
'with location_ids as(
	select child_id
	from location_hierchy_closer_det
	where parent_id in (select id from location_master where type = ''S'')
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
		lid.child_id
	from tr_training_attendee_rel ttar
		inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
		left join tr_training_additional_attendee_rel ttaar on ttaar.training_id = ttar.training_id
		inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
		inner join um_user_location uul on ttar.attendee_id = uul.user_id
		and uul.state = ''ACTIVE''
		inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
		left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id
		and uul2.state = ''ACTIVE''
		left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id
		inner join location_ids lid on lid.child_id = lhcd.parent_id
		or lid.child_id = lhcd2.parent_id
	where ttcr.course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
	group by lid.child_id
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_learning_usage_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'57c070d9-34fd-4c4c-a266-76c461383094', 97070,  current_date , 97070,  current_date , 'lms_retrieve_learning_usage_data',
 null,
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
	where parent_id in (
			select id
			from location_master
			where type = ''S''
		)
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