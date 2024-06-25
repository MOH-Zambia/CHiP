insert into menu_config(active,menu_name,navigation_state,menu_type)
select true,'LMS Dashboard V2','techo.manage.lmsdashboardv2','training'
WHERE NOT exists(select 1 from menu_config where menu_name='LMS Dashboard V2');


drop table if exists lms_dashboard_role_mapping;
create table if not exists lms_dashboard_role_mapping(
	id serial PRIMARY KEY,
	code character varying (200),
	role_id integer,
	"state" character varying (200)
);


insert into lms_dashboard_role_mapping (code,role_id,"state")
values('state-map',96,'ACTIVE'),
('learningapp-usage-kpi',96,'ACTIVE'),
('user-count-kpi',96,'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_weekly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'cf234242-c687-4084-956a-dd068cea858c', 97070,  current_date , 97070,  current_date , 'lms_count_of_users_coursewise_weekly',
'locationId,roleId,courseId',
'with base_data as(select count(distinct tsa.user_id),date_trunc(''month'',started_on) as started_on from tr_session_analytics tsa
inner join um_user_location uul on tsa.user_id = uul.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
where lesson_id in (select distinct lesson_id from tr_lesson_analytics tla where course_id = #courseId#) and lhcd.parent_id =#locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by date_trunc(''month'',started_on)),
months as (select
    generate_series(
        current_date - interval ''6'' day,
        current_date, ''1 day''
    ) as week)
select months.week, coalesce(base_data.count,0) as count from months
left join base_data on months.week=base_data.started_on',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_count_of_users_coursewise_monthly';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0409f66b-1a17-49f2-b8d9-d553fea8ab2e', 97070,  current_date , 97070,  current_date , 'lms_count_of_users_coursewise_monthly',
'locationId,roleId,courseId',
'with base_data as(select count(distinct tsa.user_id),date_trunc(''month'',started_on) as started_on from tr_session_analytics tsa
inner join um_user_location uul on tsa.user_id = uul.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
where lesson_id in (select distinct lesson_id from tr_lesson_analytics tla where course_id = #courseId#) and lhcd.parent_id =#locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end
group by date_trunc(''month'',started_on)),
months as (select
    generate_series(
        date_trunc(''month'',current_date - interval ''11'' month),
        current_date, ''1 month''
    ) as month)
select months.month, coalesce(base_data.count,0) as count from months
left join base_data on months.month=base_data.started_on',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_course_engagement_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d15d603-e3f6-42e6-a7d2-fd399b896947', 97070,  current_date , 97070,  current_date , 'lms_course_engagement_data',
'locationId,roleId',
'with counts as(select count(distinct tcwca.user_id) as users, tcwca.course_id
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id  and uul.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join um_user uu on uu.id = tcwca.user_id and uu.state=''ACTIVE''
where tcwca.course_progress = 100 and lhcd.parent_id = #locationId#
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
	left join um_user_location uul2 on ttaar.additional_attendee_id = uul2.user_id  and uul2.state=''ACTIVE''
	left join location_hierchy_closer_det lhcd2 on lhcd2.child_id = uul2.loc_id and lhcd2.parent_id = #locationId#	where tcm.course_state = ''ACTIVE'' and tcm.course_type=''ONLINE''
	and lhcd.parent_id = #locationId#
	group by ttcr.course_id ,tcm.course_name
)
select course_details.course_id,course_details.course_name,
(COALESCE(course_counts.users,0)*100)/course_details.enrolled_user_id as completion_rate
from course_counts
right join course_details on
course_details.course_id=course_counts.course_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_learning_app_usage_active_users';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'125e16e7-d675-498c-9118-d9769b8ee8df', 97070,  current_date , 97070,  current_date , 'lms_dashboard_learning_app_usage_active_users',
'locationId,roleId,courseId',
'select count(distinct tcwca.user_id) as total,count(distinct tcwca.user_id) filter (where course_progress = 100) as "100%completed",
count(distinct tcwca.user_id) filter (where course_progress < 100 and course_progress >=75 ) as "75%completed",
count(distinct tcwca.user_id) filter (where course_progress < 75 and course_progress >=50 ) as "50%completed",
count(distinct tcwca.user_id) filter (where course_progress < 50 and course_progress >=25 ) as "25%complete",
count(distinct tcwca.user_id) filter (where course_progress < 25) as "lessthan25%completed" from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on tcwca.user_id = uul.user_id and uul.state = ''ACTIVE''
inner join location_hierchy_closer_det lhcd on uul.loc_id = lhcd.child_id
inner join um_user uu on uu.id = uul.user_id and uu.state = ''ACTIVE''
where course_id = #courseId# and lhcd.parent_id = #locationId#
and case when #roleId# is not null then uu.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97070,  current_date , 97070,  current_date , 'lms_heatmap_data',
'roleId,courseId',
'with location_ids as(
select child_id from location_hierchy_closer_det where parent_id = 555800 and depth = 1
),
user_count as(select
count (distinct tcwca.user_id),lhcd.parent_id
from tr_course_wise_count_analytics tcwca
inner join um_user_location uul on uul.user_id=tcwca.user_id and uul.state=''ACTIVE''
inner join um_user uu on uu.id = uul.user_id and uu.state=''ACTIVE''
inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
inner join location_ids lid on lid.child_id=lhcd.parent_id
where course_id=#courseId#
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
when series_label between 50 and 84 then ''#40bf40''
when series_label between 25 and 49 then ''#9fdf9f''
when series_label between 0 and 24 then ''#c6ecc6''
end as color
from analytics',
null,
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_lms_dashboard_kpi_codes_by_role_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'52c6139b-5f76-4771-9056-366486c25fca', 97070,  current_date , 97070,  current_date , 'retrieve_lms_dashboard_kpi_codes_by_role_id',
'roleId',
'select * from lms_dashboard_role_mapping where role_id = #roleId# and state=''ACTIVE''',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_engagement_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'71d78981-72af-4625-860d-44c71bb40e9b', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_course_engagement_v2',
'locationId,roleId,courseId',
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
	count(1) filter (where (course_progress is null or course_progress < 100)) as in_progress,
	count(1) filter (where course_progress = 100) as completed
	from enrolled_data
	inner join tr_course_wise_count_analytics on enrolled_data.user_id = tr_course_wise_count_analytics.user_id
	and tr_course_wise_count_analytics.course_id = #courseId#
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
	and um_role_master.state = ''ACTIVE''
	where case when #roleId# is not null then roles.role_id = cast(#roleId# as integer) else true end',
null,
true, 'ACTIVE');