--lms_dashboard_retrieve_modules_by_course_id
DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_modules_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e338408e-f1f5-4d51-9048-787ec1ff920f', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_modules_by_course_id',
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
            where course_id = #courseId#)
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