DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_learning_app_usage_active_users';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'125e16e7-d675-498c-9118-d9769b8ee8df', 97157,  current_date , 97157,  current_date , 'lms_dashboard_learning_app_usage_active_users',
'locationId,roleId,courseId',
'select count(distinct tcwca.user_id) as total,count(distinct tcwca.user_id) filter (where course_progress = 100) as "100%completed",
count(distinct tcwca.user_id) filter (where course_progress < 100 and course_progress >=75 ) as "75%completed",
count(distinct tcwca.user_id) filter (where course_progress < 75 and course_progress >=50 ) as "50%completed",
count(distinct tcwca.user_id) filter (where course_progress < 50 and course_progress >=25 ) as "25%complete",
count(distinct tcwca.user_id) filter (where course_progress between 1 and 24) as "lessthan25%completed" from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id and uul.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
where course_id = #courseId# and lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71d78981-72af-4625-860d-44c71bb40e9b', 97157,  current_date , 97157,  current_date , 'lms_dashboard_retrieve_course_engagement_v2',
'locationId,roleId,courseId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id = #courseId#
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
		and tr_course_wise_count_analytics.course_id = #courseId#
	group by enrolled_data.role_id
),
not_started as (
	select enrolled_data.role_id,
		count(1) filter (
			where tr_user_meta_data.user_id is null
		) as not_started
	from enrolled_data
		left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
		and tr_user_meta_data.course_id = #courseId#
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c7b5471e-211f-48f1-9b14-d8a10e09269f', 97157,  current_date , 97157,  current_date , 'lms_dashboard_retrieve_enrolled_by_course_id_v2',
'offSet,locationId,limit,courseId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel where course_id = #courseId#
), enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
), location_users as (
	select distinct user_id
    from location_hierchy_closer_det
        inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
    where parent_id = #locationId#
),course_status as (
	select distinct location_users.user_id as enrolled_user_id,
	tr_user_meta_data.user_id as user_id,
	tr_user_meta_data.is_course_completed
	from location_users
	left join tr_user_meta_data on location_users.user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
),course_time as (
	select distinct user_id,
	min(started_on) as course_started_on,
	max(ended_on) as course_ended_on
	from tr_lesson_analytics
	where course_id = #courseId#
	group by user_id
)
select DISTINCT um_user.id as "userId",
um_user.user_name as "userName",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "name",
um_role_master.name as "roleName",
case when course_status.user_id is null or course_time.course_started_on is null then ''NOT_YET_STARTED''
	 when course_status.user_id is not null and course_time.course_started_on is not null and (course_status.is_course_completed is null or course_status.is_course_completed is false) then ''IN_PROGRESS''
	 when course_status.user_id is not null and course_status.is_course_completed is true then ''COMPLETED''
	 end as "courseStatus",
to_char(course_time.course_started_on,''DD/MM/YYYY HH24:MI:SS'') as "courseStartedOn",
case when course_status.is_course_completed then to_char(course_time.course_ended_on,''DD/MM/YYYY HH24:MI:SS'') end as "courseEndedOn",
(case when uuld.id is not null then ''Yes'' else ''No'' end) as "isLoggedIn"
from location_users
inner join um_user on location_users.user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''
left join course_status on location_users.user_id = course_status.enrolled_user_id
left join course_time on location_users.user_id = course_time.user_id
left join um_user_login_det uuld on uuld.user_id = um_user.id and uuld.logging_from_web is false
order by um_role_master.name
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');