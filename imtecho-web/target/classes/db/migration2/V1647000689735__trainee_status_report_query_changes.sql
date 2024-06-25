DELETE FROM QUERY_MASTER WHERE CODE='training_dashboard_pending_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'eaf13434-a4e9-49c8-8c5f-9d05c76cf9c9', 97063,  current_date , 97063,  current_date , 'training_dashboard_pending_list',
'courseType,trainingId,locationId,loggedInUserId',
'with location_det as(
	select distinct child_id as loc_id
	from location_hierchy_closer_det
	where case when #locationId# is not null
			   then parent_id in (#locationId#)
		   	   else parent_id in (select distinct loc_id from um_user_location where user_id = #loggedInUserId# and state = ''ACTIVE'') end
),users AS (
SELECT tcrr.role_id, tcrr.course_id, uu.id,tr_course_master.module_id FROM
	tr_course_master
	inner join tr_course_role_rel tcrr on tcrr.course_id = tr_course_master.course_id and tr_course_master.course_state = ''ACTIVE''
	INNER JOIN um_user uu ON uu.role_id = tcrr.role_id and uu.state = ''ACTIVE''
	inner join um_user_location ul on ul.state = ''ACTIVE'' and ul.user_id = uu.id
       	inner join location_det ld on ld.loc_id = ul.loc_id
    where tr_course_master.course_type = #courseType#
    and case when #trainingId# is not null then tr_course_master.course_id in (
    	select course_id
    	from tr_training_course_rel
    	where training_id = #trainingId#
    ) else true end

),totalUser as
(select u.course_id,u.role_id,COALESCE(count(distinct u.id),0) total from users u GROUP BY u.course_id,u.role_id)
, course_completion_time as (
	select users.course_id,
	users.id as user_id,
	min(tr_lesson_analytics.started_on) as course_started_on,
	max(tr_lesson_analytics.ended_on) as course_ended_on
	from users
	inner join tr_lesson_analytics on users.course_id = tr_lesson_analytics.course_id
	and users.id = tr_lesson_analytics.user_id
	group by users.course_id,
	users.id
),scheduled as (
		select count(distinct us.id) as scheduled,us.course_id,us.role_id,
		count(distinct tr_user_meta_data.user_id) filter (where tr_user_meta_data.is_course_completed is null or tr_user_meta_data.is_course_completed is false) as in_progress,
		count(distinct tr_user_meta_data.user_id) filter (where tr_user_meta_data.is_course_completed) as completed,
		count(distinct tr_user_meta_data.user_id) filter (where tr_user_meta_data.is_course_completed and cast(imt_family.created_on as date) >= cast(course_completion_time.course_ended_on as date)) as online_practicing_users
		from tr_training_master tr
		inner join tr_training_course_rel tcr on tr.training_id = tcr.training_id
                 inner join (select * from tr_training_attendee_rel union select * from tr_training_additional_attendee_rel) r
                 on tr.training_id = r.training_id
	         right join users us on us.id = r.attendee_id and us.course_id = tcr.course_id
	         left join tr_user_meta_data on us.id = tr_user_meta_data.user_id
	         and us.course_id = tr_user_meta_data.course_id
	         left join imt_family on tr_user_meta_data.user_id = imt_family.created_by
	         and case when #locationId# is null then true else imt_family.location_id in (select distinct child_id from location_hierchy_closer_det where parent_id in (#locationId#)) end
	         and tr_user_meta_data.is_course_completed
	         left join course_completion_time on tr_user_meta_data.user_id = course_completion_time.user_id
	         and tr_user_meta_data.course_id = course_completion_time.course_id
	         and tr_user_meta_data.is_course_completed
                 where (case when #courseType# = ''ONLINE'' then true else tr.expiration_date >= current_date end) and tr.training_state = ''DRAFT''
                 and case when #trainingId# is not null then tr.training_id = #trainingId# else true end
                 --where tr.training_state = ''DRAFT''
                 group by us.course_id,us.role_id
),
practiced as (
	SELECT us.role_id, us.course_id, COALESCE(count(distinct us.id),0) as practiced from tr_certificate_master tcm
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	left join user_form_access ufa on ufa.form_code = fvm.value and ufa.user_id = us.id
	INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
    and case when #trainingId# is not null then ttm.training_id = #trainingId# else true end
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id in (1,7,10,11,26)
	and ufa.form_code is null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION''
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
),production as (
	SELECT us.role_id, us.course_id, count(distinct us.id) as production from tr_certificate_master tcm
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	--inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	--left join user_form_access ufa on ufa.form_code = fvm.value
	INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
    and case when #trainingId# is not null then ttm.training_id = #trainingId# else true end
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id not in (1,7,10,11,26)
	--and ufa.form_code is null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION''
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
	union all
	SELECT us.role_id, us.course_id, count(distinct us.id) as production from tr_certificate_master tcm
	INNER JOIN users us on us.id = tcm.user_id and tcm.course_id = us.course_id
	inner join listvalue_field_value_detail fvm on fvm.id = us.module_id
	inner join user_form_access ufa on ufa.form_code = fvm.value and ufa.user_id = us.id
	INNER JOIN tr_training_master ttm ON tcm.training_id = ttm.training_id
    and case when #trainingId# is not null then ttm.training_id = #trainingId# else true end
	--INNER JOIN tr_course_master cm on cm.course_id = tcm.course_id
	where tcm.certificate_type = ''COURSECOMPLETION'' and us.course_id in (1,7,10,11,26) and ufa.state=''MOVE_TO_PRODUCTION''
	--and ufa.form_code is not null
	--ttm.training_state = ''SUBMITTED'' and tcm.certificate_type = ''COURSECOMPLETION''
	--and us.state = ''ACTIVE'' and cm.course_state=''ACTIVE''
	group by us.course_id,us.role_id
),
pending as (
	SELECT totalUser.total - (COALESCE(scheduled,0)+ COALESCE(practiced,0)+COALESCE(production,0)) as pending,totalUser.course_id ,totalUser.role_id from totalUser

	LEFT JOIN scheduled ON totalUser.course_id = scheduled.course_id AND totalUser.role_id = scheduled.role_id
	LEFT JOIN practiced ON totalUser.course_id = practiced.course_id AND totalUser.role_id = practiced.role_id
LEFT JOIN production ON totalUser.course_id = production.course_id AND totalUser.role_id = production.role_id
	INNER JOIN tr_course_master tcm ON totalUser.course_id = tcm.course_id
	INNER JOIN um_role_master urm ON totalUser.role_id = urm.id
)
SELECT  totalUser.course_id as "id",
	tcm.course_name as "courseName",
	urm.name as role,
	totalUser.role_id as "roleId",
	totalUser.total,
	COALESCE(scheduled.scheduled,0) as scheduled,
	COALESCE(scheduled.in_progress,0) as in_progress,
	COALESCE(scheduled.completed,0) as completed,
	COALESCE(scheduled.online_practicing_users,0) as online_practicing_users,
	COALESCE(practiced,0) as practicing,
	COALESCE(production,0) as production ,
        pending
	FROM totalUser

	LEFT JOIN production ON totalUser.course_id = production.course_id AND totalUser.role_id = production.role_id
	LEFT JOIN scheduled ON totalUser.course_id = scheduled.course_id AND totalUser.role_id = scheduled.role_id
	LEFT JOIN practiced ON totalUser.course_id = practiced.course_id AND totalUser.role_id = practiced.role_id
	LEFT JOIN pending ON totalUser.course_id = pending.course_id AND totalUser.role_id = pending.role_id
	INNER JOIN tr_course_master tcm ON totalUser.course_id = tcm.course_id
	INNER JOIN um_role_master urm ON totalUser.role_id = urm.id;',
null,
true, 'ACTIVE');