DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_by_course_id_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c7b5471e-211f-48f1-9b14-d8a10e09269f', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_enrolled_by_course_id_v2',
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
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
case when course_status.user_id is null then ''NOT_YET_STARTED''
	 when course_status.user_id is not null and (course_status.is_course_completed is null or course_status.is_course_completed is false) then ''IN_PROGRESS''
	 when course_status.user_id is not null and course_status.is_course_completed is true then ''COMPLETED''
	 end as "courseStatus",
to_char(course_time.course_started_on,''DD/MM/YYYY HH24:MI:SS'') as "courseStartedOn",
to_char(course_time.course_ended_on,''DD/MM/YYYY HH24:MI:SS'') as "courseEndedOn",
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


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_roles_for_lms_dashboard_based_on_course';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b830475c-e7ae-41ad-a24e-fe44cd3781c5', 97157,  current_date , 97157,  current_date , 'retrieve_roles_for_lms_dashboard_based_on_course',
'courseId',
'select urm.* from um_role_master urm
inner join tr_course_role_rel tcrr on tcrr.role_id = urm.id
where tcrr.course_id = #courseId#',
null,
true, 'ACTIVE');