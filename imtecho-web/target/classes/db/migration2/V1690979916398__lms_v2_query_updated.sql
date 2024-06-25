DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71d78981-72af-4625-860d-44c71bb40e9b', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_course_engagement_v2',
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
					or course_progress < 100
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
um_user.user_name as "userName",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "name",
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


DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97070,  current_date , 97070,  current_date , 'lms_heatmap_data',
'roleId,courseId',
'with location_ids as(
select child_id from location_hierchy_closer_det where parent_id = 2 and depth = 2
),
user_count as(select
count (distinct tcwca.user_id),lhcd.parent_id
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on uul.user_id=tcwca.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join location_ids lid on lid.child_id=lhcd.parent_id
where course_id=#courseId# and course_progress=100
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by lhcd.parent_id),
total_count as (select count(distinct attendee_id)+count(distinct additional_attendee_id) as enrolled_user_id,ttcr.course_id,lid.child_id
	from tr_training_attendee_rel ttar
	inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
	left join tr_training_additional_attendee_rel ttaar on ttaar.training_id =ttar .training_id
	inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
	inner join um_user_location uul on ttar.attendee_id = uul.user_id and uul.state=''ACTIVE''
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
	left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id and uul2.state=''ACTIVE''
	left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id
	inner join location_ids lid on lid.child_id=lhcd.parent_id or lid.child_id=lhcd2.parent_id
	where ttcr.course_id=#courseId#
	group by ttcr.course_id,lid.child_id),
analytics as(select
("count"*100)/enrolled_user_id as series_label,
lm.id,lm.english_name as x_axis_label
from total_count
left join user_count on total_count.child_id=user_count.parent_id
inner join location_master lm on lm.id=total_count.child_id)
select x_axis_label,series_label,
case
when series_label between 85 and 100 then ''#1e621e''
when series_label between 50 and 84 then ''#ffcc00''
when series_label between 25 and 49 then ''#ff751a''
when series_label between 0 and 24 then ''#ff6666''
end as color
from analytics',
null,
true, 'ACTIVE');