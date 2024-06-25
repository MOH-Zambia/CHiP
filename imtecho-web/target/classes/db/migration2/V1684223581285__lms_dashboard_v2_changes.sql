DELETE FROM QUERY_MASTER WHERE CODE='lms_course_engagement_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'3d15d603-e3f6-42e6-a7d2-fd399b896947', 97070,  current_date , 97070,  current_date , 'lms_course_engagement_data',
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