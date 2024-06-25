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
where (#courseId# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'') and lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71d78981-72af-4625-860d-44c71bb40e9b', 97081,  current_date , 97081,  current_date , 'lms_dashboard_retrieve_course_engagement_v2',
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
	select distinct location_users.user_id,
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
		and (#courseId# is null or tr_course_wise_count_analytics.course_id = #courseId#) and tr_course_wise_count_analytics.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
	group by enrolled_data.role_id
),
not_started as (
	select enrolled_data.role_id,
	count(1) filter (where tr_user_meta_data.user_id is null and uuld2.user_id is not null) as not_started
	from enrolled_data
	left join tr_user_meta_data on enrolled_data.user_id = tr_user_meta_data.user_id
	inner join um_user_login_det uuld2 on uuld2.user_id = enrolled_data.user_id
	and (#courseId# is null or tr_user_meta_data.course_id = #courseId#) and tr_user_meta_data.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_learning_app_usage_active_users_for_all_role';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5e71f766-28cf-434a-9958-89d37e2cf34d', 97081,  current_date , 97081,  current_date , 'lms_dashboard_learning_app_usage_active_users_for_all_role',
'locationId,roleId,courseId',
'select count( tcwca.user_id) as total,count( tcwca.user_id) filter (where course_progress = 100) as "100%completed",
count( tcwca.user_id) filter (where course_progress < 100 and course_progress >=75 ) as "75%completed",
count( tcwca.user_id) filter (where course_progress < 75 and course_progress >=50 ) as "50%completed",
count( tcwca.user_id) filter (where course_progress < 50 and course_progress >=25 ) as "25%complete",
count( tcwca.user_id) filter (where course_progress between 1 and 24) as "lessthan25%completed" from tr_course_wise_count_analytics tcwca
where (#courseId# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
and tcwca.user_id in (select distinct user_id from um_user_location uul
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
and lhcd.parent_id = #locationId# and uul.state = ''ACTIVE''
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end)',
null,
true, 'ACTIVE');