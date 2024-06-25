DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_completors_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7817d22e-60a7-4eec-b080-c792f05c7ea4', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_course_completors_v2',
'courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id in (select id from location_master where type = ''S'')
), course_completion as (
	select tr_lesson_analytics.user_id as user_id,
	sum(spent_time) as spent_time,
	min(tr_lesson_analytics.started_on) as course_started_on,
	max(tr_lesson_analytics.ended_on) as course_ended_on
	from tr_lesson_analytics
    inner join location_user on location_user.user_id=tr_lesson_analytics.user_id
	inner join tr_user_meta_data on tr_lesson_analytics.user_id = tr_user_meta_data.user_id
	and tr_lesson_analytics.course_id = tr_user_meta_data.course_id
	where (case when #courseId# is not null then tr_lesson_analytics.course_id = #courseId# else true end)
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
		 else concat(CAST(extract(second from spent_time)as numeric(10,2)),'' sec'')
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
		 else concat(cast(extract(second from (course_ended_on - course_started_on)) as numeric(10,2)),'' sec'')
		 end
) as "finishedIn"
from course_completion
inner join um_user on course_completion.user_id = um_user.id
and um_user.state = ''ACTIVE''
order by (course_ended_on - course_started_on);',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_district_performance_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'23fc04c3-28de-45b4-9f48-42dbf9109770', 97070,  current_date , 97070,  current_date , 'lms_retrieve_district_performance_data',
'courseId',
'with locations as(
    select DISTINCT child_id
    from location_hierchy_closer_det
    where parent_id in (select id from location_master where type=''S'') and depth = 1
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
        inner join tr_course_wise_count_analytics tcwca on uu.id = tcwca.user_id
        where (case when #courseId# is not null then tcwca.course_id = #courseId# else true end)
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
        inner join tr_training_attendee_rel ttar on uu.id = ttar.attendee_id
        inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id and
        (case when #courseId# is not null then ttcr.course_id = #courseId# else true end)
        left join tr_training_additional_attendee_rel ttaar on ttaar.additional_attendee_id = uu.id and ttcr.training_id = ttaar.training_id
    group by locations.child_id
)
select lm.name,
    COALESCE((COALESCE(counts.users, 0) * 100) / course_details.enrolled_user_id,0) as completion_rate
    from locations
    inner join location_master lm on lm.id = locations.child_id
    left join counts on counts.child_id = locations.child_id
    left join course_details on course_details.child_id = locations.child_id',
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
	where parent_id = 2
		and depth = 2
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
		when series_label between 50 and 75 then ''#ffbb00''
		when series_label between 25 and 49 then ''#ff6600''
		when series_label between 0 and 24 then ''#cc0000''
	end as color
from analytics',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_header_data_for_total_users';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'17cefd02-43d6-42bc-abaf-482758fe5544', 97070,  current_date , 97070,  current_date , 'lms_header_data_for_total_users',
'locationId',
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
				select id
				from location_master
				where type = ''S''
			)
			else parent_id = #locationId# end)
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
months as (
	select generate_series(
			date_trunc(''month'', current_date - interval ''11'' month),
			current_date,
			''1 month''
		) as month
),
active_users as(
	select count(distinct tsa.user_id),
		date_trunc(''month'', started_on) as started_on
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		and uu.state = ''ACTIVE''
		left join tr_session_analytics tsa on tsa.user_id = enrolled_data.user_id
	group by date_trunc(''month'', started_on)
),
appinstalled_users as(
	select count(distinct uuld.user_id) filter(
			where uuld.created_on <= months.month
		),
		date_trunc(''month'', months.month) as created_on
	from enrolled_data
		cross join months
		inner join um_user uu on enrolled_data.user_id = uu.id
		and uu.state = ''ACTIVE''
		left join (
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
coalesce(final_users.count, 0) as "totalEnrolled" from months
	cross join final_users
left join active_users on months.month = active_users.started_on
left join appinstalled_users on months.month = appinstalled_users.created_on',
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
					or course_progress between 0 and 99
				)
		) as in_progress,
		count(1) filter (
			where course_progress = 100
		) as completed,
		count(course_analytics.user_id) filter (
			where course_progress < 100
				and course_progress >= 75
		) as completed_75,
		count(course_analytics.user_id) filter (
			where course_progress < 75
				and course_progress >= 50
		) as completed_50,
		count(course_analytics.user_id) filter (
			where course_progress < 50
				and course_progress >= 25
		) as completed_25,
		count(course_analytics.user_id) filter (
			where course_progress between 0 and 24
		) as less_than_25
	from enrolled_data
		inner join course_analytics on enrolled_data.user_id = course_analytics.user_id
),
not_started as (
	select count(distinct enrolled_data.user_id) as not_started
	from enrolled_data
		left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	where tr_user_meta_data.user_id is null
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_monthly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0409f66b-1a17-49f2-b8d9-d553fea8ab2e', 97070,  current_date , 97070,  current_date , 'lms_count_of_users_coursewise_monthly',
'locationId,roleId,courseId',
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
                when #locationId# is not null then lhcd.parent_id = cast(#locationId# as integer) else true end)
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
'locationId,roleId,courseId',
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
                when #locationId# is not null then lhcd.parent_id = cast(#locationId# as integer) else true end)
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_all_course_overview_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'59c10ad3-a2f2-45c6-9d32-6b8a09a69d2d', 97070,  current_date , 97070,  current_date , 'lms_retrieve_all_course_overview_data',
 null,
'with counts as(
    select count(distinct tcwca.user_id) filter(
            where tcwca.course_progress = 100
        ) as users,
        tcwca.course_id,
        avg(time_spent_on_course) as time_spent
    from tr_course_wise_count_analytics tcwca
        inner join um_user uu on uu.id = tcwca.user_id
        and uu.state = ''ACTIVE''
    group by tcwca.course_id
),
course_counts as(
    select counts.*,
        tcm.course_name
    from counts
        inner join tr_course_master tcm on tcm.course_id = counts.course_id
    where tcm.course_state = ''ACTIVE''
        and course_type = ''ONLINE''
),
course_details as(
    select count(distinct attendee_id) + count(distinct additional_attendee_id) filter(
            where uu2 is not null
        ) as enrolled_user_id,
        ttcr.course_id,
        tcm.course_name
    from tr_training_attendee_rel ttar
        inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
        left join tr_training_additional_attendee_rel ttaar on ttaar.training_id = ttar.training_id
        inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
        inner join um_user uu on uu.id = ttar.attendee_id
        and uu.state = ''ACTIVE''
        left join um_user uu2 on uu2.id = ttaar.additional_attendee_id
        and uu2.state = ''ACTIVE''
    where tcm.course_state = ''ACTIVE''
        and tcm.course_type = ''ONLINE''
    group by ttcr.course_id,
        tcm.course_name
)
select course_details.course_id,
    course_details.course_name,
    (COALESCE(course_counts.users, 0) * 100) / course_details.enrolled_user_id as completion_rate,
    date_part(''minutes'', time_spent) as time_spent
from course_counts
    right join course_details on course_details.course_id = course_counts.course_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_modules_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7cafe994-1ce7-44ba-a477-2c3219d18d36', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_modules_by_course_id_v2',
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