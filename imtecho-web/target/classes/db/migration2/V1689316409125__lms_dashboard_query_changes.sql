DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_course_completion_rate_by_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7be00e69-9448-4b58-8d76-9790b7994103', 97070,  current_date , 97070,  current_date , 'lms_dashboard_course_completion_rate_by_location',
'course_id,location_id',
'WITH training_ids as (
	select distinct training_id
	from tr_training_course_rel where course_id = #course_id#
),enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
	inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),loc_det AS (
    SELECT child_id AS id
    FROM location_hierchy_closer_det
    WHERE parent_id = #location_id#
        AND depth = 1
),data_list as (
	select distinct um_user.id AS user_id,
	lm.name AS loc_name,
	ltm.name AS loc_type,
	tcwca.course_progress AS course_progress
	FROM location_hierchy_closer_det lhcd
	INNER JOIN loc_det ON loc_det.id = lhcd.parent_id
	INNER JOIN location_master lm ON lm.id = loc_det.id
	INNER JOIN location_type_master ltm ON ltm.type=lm.type
	INNER JOIN um_user_location uul ON lhcd.child_id=uul.loc_id
	INNER JOIN um_user ON um_user.id = uul.user_id
    inner join enrolled_users
		on enrolled_users.enrolled_user_id = um_user.id
	left join tr_course_wise_count_analytics tcwca
	on enrolled_users.enrolled_user_id = tcwca.user_id
	and tcwca.course_id =#course_id#
),completion_rate AS (
select
count(CASE WHEN course_progress = 100 THEN user_id END) AS completed_count,
count(user_id) AS total_count,
loc_name AS loc_name,
loc_type AS loc_type
from data_list
GROUP BY loc_name,loc_type
),min_max_percentage AS (
    SELECT
        MIN(completed_count * 100 / total_count) AS min_percentage,
        MAX(completed_count * 100 / total_count) AS max_percentage
    FROM completion_rate
)
SELECT
    completion_rate.completed_count,
    completion_rate.total_count,
    completion_rate.loc_name,
    completion_rate.loc_type,
    CASE
	WHEN completion_rate.completed_count = 0 THEN ''Min''
        WHEN completion_rate.completed_count = completion_rate.total_count THEN ''Max''
	WHEN (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.max_percentage THEN ''Max''
        WHEN (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.min_percentage THEN ''Min''
        ELSE NULL
    END AS count_type
FROM
    completion_rate
INNER JOIN
    min_max_percentage ON (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.min_percentage
    OR (completion_rate.completed_count * 100 / completion_rate.total_count) = min_max_percentage.max_percentage
ORDER BY
    count_type;',
null,
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_course_completors';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'fe74a3c5-5c52-4d64-bb15-2bb52d774a85', 97080,  current_date , 97080,  current_date , 'lms_dashboard_retrieve_course_completors',
'locationId,courseId',
'with location_user as(
    select user_id
    from location_hierchy_closer_det
        left join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
    where parent_id = #locationId#
), course_completion as (
	select tr_lesson_analytics.user_id as user_id,
	sum(spent_time) as spent_time,
	min(tr_lesson_analytics.started_on) as course_started_on,
	max(tr_lesson_analytics.ended_on) as course_ended_on
	from tr_lesson_analytics
    inner join location_user on location_user.user_id=tr_lesson_analytics.user_id
	inner join tr_user_meta_data on tr_lesson_analytics.user_id = tr_user_meta_data.user_id
	and tr_lesson_analytics.course_id = tr_user_meta_data.course_id
	where tr_lesson_analytics.course_id = #courseId#
	and tr_user_meta_data.is_course_completed
	group by tr_lesson_analytics.user_id
)select um_user.id as "userId",
concat_ws('' '',um_user.first_name,um_user.middle_name,um_user.last_name) as "userName",
concat(
	case when (extract(day from spent_time) * 24 + extract(hour from spent_time)) <= 0
		 then ''''
		 else concat(extract(day from spent_time) * 24 + extract(hour from spent_time),'' hr '')
		 end,
	case when extract(minute from spent_time) <= 0
		 then ''''
		 else concat(extract(minute from spent_time),'' min '')
		 end,
	case when extract(second from spent_time) <= 0
		 then ''''
		 else concat(ROUND(extract(second from spent_time),2),'' sec'')
		 end
) as "spentTime",
concat(
	case when (extract(day from (course_ended_on - course_started_on)) * 24 + extract(hour from (course_ended_on - course_started_on))) <= 0
		 then ''''
		 else concat(extract(day from (course_ended_on - course_started_on)) * 24 + extract(hour from (course_ended_on - course_started_on)),'' hr '')
		 end,
	case when extract(minute from (course_ended_on - course_started_on)) <= 0
		 then ''''
		 else concat(extract(minute from (course_ended_on - course_started_on)),'' min '')
		 end,
	case when extract(second from (course_ended_on - course_started_on)) <= 0
		 then ''''
		 else concat(Round(extract(second from (course_ended_on - course_started_on)),2),'' sec'')
		 end
) as "finishedIn"
from course_completion
inner join um_user on course_completion.user_id = um_user.id
and um_user.state = ''ACTIVE''
order by (course_ended_on - course_started_on);',
null,
true, 'ACTIVE');