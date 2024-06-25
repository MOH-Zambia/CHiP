DELETE FROM QUERY_MASTER WHERE CODE='lms_retrieve_district_performance_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'23fc04c3-28de-45b4-9f48-42dbf9109770', 97070,  current_date , 97070,  current_date , 'lms_retrieve_district_performance_data',
'courseId',
'with locations as(
	select DISTINCT child_id
	from location_hierchy_closer_det
	where parent_id in (
			select id
			from location_master
			where type = ''S''
		)
		and depth = 1
),
counts as(
	select count(distinct tcwca.user_id) filter(
			where tcwca.course_progress = 100
		) as users,
		locations.child_id
	from locations
		inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
		inner join um_user_location uul on uul.loc_id = lhcd.child_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join tr_course_wise_count_analytics tcwca on uu.id = tcwca.user_id
	where (
			case
				when #courseId# is not null then tcwca.course_id = #courseId# else true end)
				group by locations.child_id
			),
			course_details as(
				select count(distinct attendee_id) + count(distinct additional_attendee_id) filter(
						where ttaar is not null
					) as enrolled_user_id,
					locations.child_id
				from locations
					inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
					inner join um_user_location uul on uul.loc_id = lhcd.child_id
					and uul.state = ''ACTIVE''
					inner join um_user uu on uu.id = uul.user_id
					and uu.state = ''ACTIVE''
					inner join um_user_login_det uuld on uuld.user_id = uu.id
					inner join tr_training_attendee_rel ttar on uu.id = ttar.attendee_id
					inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
					and (
						case
							when #courseId# is not null then ttcr.course_id = #courseId# else true end)
							left join tr_training_additional_attendee_rel ttaar on ttaar.additional_attendee_id = uu.id
							and ttcr.training_id = ttaar.training_id
							group by locations.child_id
						)
						select lm.name,
							COALESCE(
								(COALESCE(counts.users, 0) * 100) / course_details.enrolled_user_id,
								0
							) as completion_rate
						from locations
							inner join location_master lm on lm.id = locations.child_id
							inner join counts on counts.child_id = locations.child_id
							inner join course_details on course_details.child_id = locations.child_id',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_heatmap_data';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6cbf4e2a-a6b9-4886-b8c3-2891717eea2c', 97070,  current_date , 97070,  current_date , 'lms_heatmap_data',
 null,
'with location_ids as(
	select child_id
	from location_hierchy_closer_det
	where parent_id in (
			select id
			from location_master
			where type = ''S''
		)
		and depth = 1
),
user_count as(
	select count (distinct tcwca.user_id),
		lhcd.parent_id
	from tr_course_wise_count_analytics tcwca
		inner join um_user_location uul on uul.user_id = tcwca.user_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
		inner join location_ids lid on lid.child_id = lhcd.parent_id
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
		and course_progress = 100
	group by lhcd.parent_id
),
total_count as (
	select count(distinct attendee_id) + count(distinct additional_attendee_id) as enrolled_user_id,
		locations.child_id
	from location_ids as locations
		inner join location_hierchy_closer_det lhcd on lhcd.parent_id = locations.child_id
		inner join um_user_location uul on uul.loc_id = lhcd.child_id
		and uul.state = ''ACTIVE''
		inner join um_user uu on uu.id = uul.user_id
		and uu.state = ''ACTIVE''
		inner join um_user_login_det uuld on uuld.user_id = uu.id
		inner join tr_training_attendee_rel ttar on uu.id = ttar.attendee_id
		inner join tr_training_course_rel ttcr on ttcr.training_id = ttar.training_id
		left join tr_training_additional_attendee_rel ttaar on ttaar.additional_attendee_id = uu.id
		and ttcr.training_id = ttaar.training_id
	group by locations.child_id
),
analytics as(
	select ("count" * 100) / enrolled_user_id as series_label,
		lm.id,
		lm.english_name as x_axis_label
	from total_count
		left join user_count on total_count.child_id = user_count.parent_id
		inner join location_master lm on lm.id = total_count.child_id
)
select x_axis_label,
	series_label,
	case
		when series_label = 100 then ''#006600''
		when series_label between 76 and 99 then ''#3399ff''
		when series_label between 51 and 75 then ''#ffbb00''
		when series_label between 26 and 50 then ''#ff6600''
		when series_label between 1 and 25 then ''#cc0000''
	end as color
from analytics',
null,
true, 'ACTIVE');