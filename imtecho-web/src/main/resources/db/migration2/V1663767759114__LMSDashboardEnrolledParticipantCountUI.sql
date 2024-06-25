DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_enrolled_count_by_course_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2c8c0445-6fa7-4e0b-8171-3eb8346d82ea', 97091,  current_date , 97091,  current_date , 'lms_dashboard_retrieve_enrolled_count_by_course_id',
'locationId,courseId',
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
)select count(1) as "totalEnrolled" from users
     inner join location_user on users.enrolled_user_id = location_user.user_id',
null,
true, 'ACTIVE');