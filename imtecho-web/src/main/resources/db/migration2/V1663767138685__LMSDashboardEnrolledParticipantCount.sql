DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'33b040e5-cd17-4765-acf5-5179a8302654', 97091,  current_date , 97091,  current_date , 'lms_dashboard_retrieve_enrolled_by_course_id',
'offSet,locationId,limit,courseId',
'with location_user as(
    select distinct(user_id)
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
), users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	where training_id in (select distinct training_id from tr_topic_coverage_master where course_id = #courseId#)
),course_status as (
	select users.enrolled_user_id as enrolled_user_id,
	tr_user_meta_data.user_id as user_id,
	tr_user_meta_data.is_course_completed
	from users
	left join tr_user_meta_data on users.enrolled_user_id = tr_user_meta_data.user_id
	and tr_user_meta_data.course_id = #courseId#
),course_time as (
	select user_id,
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
from users
inner join um_user on users.enrolled_user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join location_user on users.enrolled_user_id = location_user.user_id
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''
inner join course_status on users.enrolled_user_id = course_status.enrolled_user_id
left join course_time on users.enrolled_user_id = course_time.user_id
order by um_user.id
limit #limit# offset #offSet#',
null,
true, 'ACTIVE');