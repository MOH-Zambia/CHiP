DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97075,  current_date , 97075,  current_date , 'lms_heatmap_data',
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
when series_label between 0 and 24 then ''#ff0000''
end as color
from analytics',
null,
true, 'ACTIVE');