--lms_dashboard_retrieve_course_engagement

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'45bc05a7-726c-41cf-a18c-c39f6cca6f76', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_course_engagement',
'locationId,courseId',
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
), enrolled_data as (
	select
		location_users.user_id, um_user.role_id as role_id
	from location_users
	inner join um_user on location_users.user_id = um_user.id
	and um_user.state = ''ACTIVE''
), roles as (
	select distinct role_id
	from enrolled_data
), enrolled as (
	select enrolled_data.role_id as role_id,
	count(1) as enrolled
	from enrolled_data
	group by enrolled_data.role_id
), course_status as (
	select enrolled_data.role_id as role_id,
	count(1) filter (where (is_course_completed is null or is_course_completed is false)) as in_progress,
	count(1) filter (where is_course_completed) as completed
	from enrolled_data
	inner join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
	group by enrolled_data.role_id
), not_started as (
	select enrolled_data.role_id,
	count(1) filter (where tr_user_meta_data.user_id is null) as not_started
	from enrolled_data
	left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
	group by enrolled_data.role_id
)
select
	um_role_master.id as "roleId",
	um_role_master.name as "roleName",
	coalesce(enrolled.enrolled,0) as "enrolled",
	coalesce(not_started.not_started,0) as "notStarted",
	coalesce(course_status.in_progress,0) as "inProgress",
	coalesce(course_status.completed,0) as "completed"
from roles
left join enrolled on roles.role_id = enrolled.role_id
left join course_status on roles.role_id = course_status.role_id
left join not_started on roles.role_id = not_started.role_id
inner join um_role_master on roles.role_id = um_role_master.id
	and um_role_master.state = ''ACTIVE''',
null,
true, 'ACTIVE');





--lms_dashboard_retrieve_enrolled_by_course_id
DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'33b040e5-cd17-4765-acf5-5179a8302654', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_enrolled_by_course_id',
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
select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
case when course_status.user_id is null then ''NOT_YET_STARTED''
	 when course_status.user_id is not null and (course_status.is_course_completed is null or course_status.is_course_completed is false) then ''IN_PROGRESS''
	 when course_status.user_id is not null and course_status.is_course_completed is true then ''COMPLETED''
	 end as "courseStatus",
to_char(course_time.course_started_on,''DD/MM/YYYY HH24:MI:SS'') as "courseStartedOn",
to_char(course_time.course_ended_on,''DD/MM/YYYY HH24:MI:SS'') as "courseEndedOn"
from location_users
inner join um_user on location_users.user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''
left join course_status on location_users.user_id = course_status.enrolled_user_id
left join course_time on location_users.user_id = course_time.user_id
order by um_role_master.name
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');