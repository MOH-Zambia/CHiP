DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_course_completion_rate_by_location_for_all_role_v2';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd5f083af-2300-472d-989c-7e4d1a73560e', 97081,  current_date , 97081,  current_date , 'lms_dashboard_course_completion_rate_by_location_for_all_role_v2',
'course_id,location_id',
'WITH training_ids as (
	select distinct training_id
	from tr_training_course_rel
	WHERE
        (#course_id#  IS NULL OR course_id = #course_id# )
        	and course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
and course_type = ''ONLINE'')
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
)
,data_list as (
	select distinct um_user.id AS user_id,
	lm.name AS loc_name,
	ltm.name AS loc_type,
	uuld.user_id as app_installed,
	tcwca.course_progress AS course_progress
	FROM location_hierchy_closer_det lhcd
	INNER JOIN loc_det ON loc_det.id = lhcd.parent_id
	INNER JOIN location_master lm ON lm.id = loc_det.id
	INNER JOIN location_type_master ltm ON ltm.type=lm.type
	INNER JOIN um_user_location uul ON lhcd.child_id=uul.loc_id
	INNER JOIN um_user ON um_user.id = uul.user_id
    inner join enrolled_users
		on enrolled_users.enrolled_user_id = um_user.id
	inner join um_user_login_det uuld on uuld.user_id=enrolled_users.enrolled_user_id
	left join tr_course_wise_count_analytics tcwca
	on enrolled_users.enrolled_user_id = tcwca.user_id
	and (#course_id# is null or tcwca.course_id = #course_id# )
	and tcwca.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
		and course_type = ''ONLINE'')
)
,final_list as (
	select
	data_list.user_id,
	data_list.loc_name,
	data_list.loc_type,
	data_list.app_installed,
	data_list.course_progress
	from data_list
	inner join tr_course_wise_count_analytics tcwca	on tcwca.user_id = data_list.user_id
	and tcwca.course_progress = data_list.course_progress
	and tcwca.course_id in (select course_id from tr_course_master where course_state = ''ACTIVE''
		and course_type = ''ONLINE'')
),completion_rate AS (
select
count(CASE WHEN course_progress = 100 THEN user_id END) AS completed_count,
count(user_id) AS total_count,
count(app_installed) as app_installed,
loc_name AS loc_name,
loc_type AS loc_type
from final_list
GROUP BY loc_name,loc_type
),min_max_percentage AS (
    SELECT
        MIN(completed_count * 100 / total_count) AS min_percentage,
        MAX(completed_count * 100 / total_count) AS max_percentage
    FROM completion_rate
)
SELECT
    completion_rate.completed_count,
    completion_rate.app_installed as total_count,
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