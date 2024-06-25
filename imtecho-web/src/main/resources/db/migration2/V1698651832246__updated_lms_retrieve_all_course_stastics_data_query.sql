DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_all_course_overview_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'59c10ad3-a2f2-45c6-9d32-6b8a09a69d2d', 97070,  current_date , 97070,  current_date , 'lms_retrieve_all_course_overview_data',
 null,
'with counts as(
    select count(distinct tcwca.user_id) filter(
            where tcwca.course_progress = 100
        ) as users,
        tcwca.course_id,
        avg(time_spent_on_course) as time_spent
    from tr_course_wise_count_analytics tcwca
        inner join um_user uu on uu.id = tcwca.user_id
        and uu.state = ''ACTIVE''
    group by tcwca.course_id
),
course_counts as(
    select counts.*,
        tcm.course_name
    from counts
        inner join tr_course_master tcm on tcm.course_id = counts.course_id
    where tcm.course_state = ''ACTIVE''
        and course_type = ''ONLINE''
),
course_details as(
    select count(distinct attendee_id) + count(distinct additional_attendee_id) filter(
            where uu2 is not null
                and uuld2 is not null
        ) as enrolled_user_id,
        ttcr.course_id,
        tcm.course_name
    from tr_training_attendee_rel ttar
        inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
        left join tr_training_additional_attendee_rel ttaar on ttaar.training_id = ttar.training_id
        inner join tr_course_master tcm on tcm.course_id = ttcr.course_id
        inner join um_user uu on uu.id = ttar.attendee_id
        and uu.state = ''ACTIVE''
        inner join um_user_login_det uuld on uuld.user_id = uu.id
        left join um_user uu2 on uu2.id = ttaar.additional_attendee_id
        and uu2.state = ''ACTIVE''
        left join um_user_login_det uuld2 on uuld2.user_id = uu2.id
    where tcm.course_state = ''ACTIVE''
        and tcm.course_type = ''ONLINE''
    group by ttcr.course_id,
        tcm.course_name
)
select course_details.course_id,
    course_details.course_name,
    (COALESCE(course_counts.users, 0) * 100) / course_details.enrolled_user_id as completion_rate,
    date_part(''minutes'', time_spent) as time_spent
from course_counts
    right join course_details on course_details.course_id = course_counts.course_id',
null,
true, 'ACTIVE');