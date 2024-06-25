DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c7b5471e-211f-48f1-9b14-d8a10e09269f', 97074,  current_date , 97074,  current_date , 'lms_dashboard_retrieve_enrolled_by_course_id_v2',
'course_id,offSet,locationId,limit,courseId',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel where (#courseId# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
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
	and (#courseId# is null or tr_user_meta_data.course_id = #courseId#) and tr_user_meta_data.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
),course_time as (
	select distinct user_id,
	min(started_on) as course_started_on,
	max(ended_on) as course_ended_on
	from tr_lesson_analytics
	where (#course_id# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
	group by user_id
),lession_time as (
	select distinct user_id,
	sum(time_to_complete_lesson) as total_spent_time_on_lession,
	count(time_to_complete_lesson) as total_lession
	from tr_lesson_analytics where (#course_id# is null or course_id = #courseId#) and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
	group by user_id
)
select DISTINCT um_user.id as "userId",
um_user.user_name as "userName",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "name",
um_role_master.name as "roleName",
CASE
        WHEN lession_time.total_lession <> 0 THEN
            EXTRACT(EPOCH FROM lession_time.total_spent_time_on_lession) / lession_time.total_lession
        ELSE
            NULL
    END AS "averageTimeSpentOnLession",
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
left join lession_time on location_users.user_id = lession_time.user_id
left join um_user_login_det uuld on uuld.user_id = um_user.id and uuld.logging_from_web is false
order by um_role_master.name
limit #limit# offset #offSet#',
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
	count(1) filter (where tr_user_meta_data.user_id is null) as not_started
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



DELETE FROM QUERY_MASTER WHERE CODE='lms_course_engagement_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d15d603-e3f6-42e6-a7d2-fd399b896947', 97074,  current_date , 97074,  current_date , 'lms_course_engagement_data',
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
	inner join um_user_login_det uuld on uuld.user_id = uul.user_id
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