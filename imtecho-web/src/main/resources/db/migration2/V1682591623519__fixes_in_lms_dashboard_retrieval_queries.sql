--lms_dashboard_retrieve_learning_hours_by_course_id
DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_learning_hours_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8f76045a-31df-4d82-af85-71be977e10fb', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_learning_hours_by_course_id',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
)
select tr_course_master.course_id as "courseId",
cast (sum(tr_lesson_analytics.spent_time)  as text) as "timeSpent"
from tr_course_master
left join tr_lesson_analytics on tr_course_master.course_id = tr_lesson_analytics.course_id
 inner join location_user on tr_lesson_analytics.user_id = location_user.user_id
where tr_course_master.course_id = #courseId#
group by tr_course_master.course_id',
null,
true, 'ACTIVE');




--lms_dashboard_retrieve_userwise_watch_hours_by_course_id
DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_userwise_watch_hours_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'b4563d5c-0f2c-4ef6-b3cc-8ef156098955', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_userwise_watch_hours_by_course_id',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
	group by user_id
), data as (
	select user_id,
	cast (sum(spent_time)  as text ) as "spent_time"
	from tr_lesson_analytics
	where course_id = #courseId#
	group by user_id
)
select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
um_role_master.name as "roleName",
data.spent_time as "timeSpent"
from data
inner join location_user on location_user.user_id=data.user_id
inner join um_user on data.user_id = um_user.id
and um_user.state = ''ACTIVE''
inner join um_role_master on um_user.role_id = um_role_master.id
and um_role_master.state = ''ACTIVE''',
null,
true, 'ACTIVE');






--lms_dashboard_retrieve_lessons_by_course_id
DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_lessons_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'85dc642c-f05b-412c-84bb-b6763c1e464c', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_lessons_by_course_id',
'locationId,courseId',
'with location_user as(
    select distinct user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
    group by user_id
), lessons as (
	select id as lesson_id,
	title as lesson_name,
	media_type as lesson_type,
	media_order as lesson_order
	from tr_topic_media_master
	where topic_id in (select topic_id from tr_course_topic_rel where course_id = #courseId#)
	and media_state = ''ACTIVE''
),frequency as (
	select lessons.lesson_id,
	count(1) as frequency
	from tr_session_analytics
	inner join lessons on tr_session_analytics.lesson_id = lessons.lesson_id
    inner join location_user on tr_session_analytics.user_id = location_user.user_id
	group by lessons.lesson_id
),hours_spent as (
	select lesson_id,
	extract(hour from sum(spent_time)) as hours_spent
	from tr_lesson_analytics
    inner join location_user on tr_lesson_analytics.user_id = location_user.user_id
	where lesson_id in (select lesson_id from lessons)
	group by lesson_id
)select lessons.lesson_id as "lessonId",
lessons.lesson_name as "lessonName",
lessons.lesson_type as "lessonType",
coalesce(frequency.frequency,0) as "frequency",
coalesce(hours_spent.hours_spent,0) as "hoursSpent"
from lessons
left join frequency on lessons.lesson_id = frequency.lesson_id
left join hours_spent on lessons.lesson_id = hours_spent.lesson_id
order by "frequency" desc',
null,
true, 'ACTIVE');
