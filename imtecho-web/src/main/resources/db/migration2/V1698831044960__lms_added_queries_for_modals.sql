DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_active_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'90be42e5-24e5-4a84-b407-c127ccbba97a', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_active_members',
'offset,locationId,limit',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
),
enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
	select distinct user_id
	from location_hierchy_closer_det
		inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
			case
				when #locationId# is null then parent_id in (
				select id
				from location_master
				where type = ''S''
			)
			else parent_id = #locationId# end)
		),
		enrolled_data as (
			select distinct location_users.user_id
			from location_users
				inner join um_user on location_users.user_id = um_user.id
				and um_user.state = ''ACTIVE''
		),
		course_status as (
			select distinct location_users.user_id as enrolled_user_id,
				tr_user_meta_data.user_id as user_id,
				tr_user_meta_data.is_course_completed
			from location_users
				left join tr_user_meta_data on location_users.user_id = tr_user_meta_data.user_id
				and tr_user_meta_data.course_id in (
					select course_id
					from tr_course_master
					where course_state = ''ACTIVE''
						and course_type = ''ONLINE''
				)
		),
		course_time as (
			select distinct user_id,
				min(started_on) as course_started_on,
				max(ended_on) as course_ended_on
			from tr_lesson_analytics
			where
				course_id in (
					select course_id
					from tr_course_master
					where course_state = ''ACTIVE''
						and course_type = ''ONLINE''
				)
			group by user_id
		),
		lession_time as (
			select distinct user_id,
				sum(time_to_complete_lesson) as total_spent_time_on_lession,
				count(time_to_complete_lesson) as total_lession
			from tr_lesson_analytics
			where course_id in (
					select course_id
					from tr_course_master
					where course_state = ''ACTIVE''
						and course_type = ''ONLINE''
				)
			group by user_id
		)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		CASE
			WHEN lession_time.total_lession <> 0 THEN EXTRACT(
				EPOCH
				FROM lession_time.total_spent_time_on_lession
			) / lession_time.total_lession
			ELSE NULL
		END AS "averageTimeSpentOnLession",
		case
			when course_status.user_id is null
			or course_time.course_started_on is null then ''NOT YET STARTED''
			when course_status.user_id is not null
			and course_time.course_started_on is not null
			and (
				course_status.is_course_completed is null
				or course_status.is_course_completed is false
			) then ''IN PROGRESS''
			when course_status.user_id is not null
			and course_status.is_course_completed is true then ''COMPLETED''
		end as "courseStatus",
		to_char(
			course_time.course_started_on,
			''DD/MM/YYYY HH24:MI:SS''
		) as "courseStartedOn",
		case
			when course_status.is_course_completed then to_char(
				course_time.course_ended_on,
				''DD/MM/YYYY HH24:MI:SS''
			)
		end as "courseEndedOn"
		from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		inner join tr_session_analytics tsa on tsa.user_id = enrolled_data.user_id
		left join course_status on enrolled_data.user_id = course_status.enrolled_user_id
left join course_time on enrolled_data.user_id = course_time.user_id
left join lession_time on enrolled_data.user_id = lession_time.user_id
	where uu.state = ''ACTIVE''
limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_app_installed_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'7462b6ee-b4f6-456e-b426-48a4cf232171', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_app_installed_members',
'offset,locationId,limit',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
),
enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
	select distinct user_id
	from location_hierchy_closer_det
		inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
			case
				when #locationId# is null then parent_id in (
				select id
				from location_master
				where type = ''S''
			)
			else parent_id = #locationId# end)
		),
		enrolled_data as (
			select distinct location_users.user_id
			from location_users
				inner join um_user on location_users.user_id = um_user.id
				and um_user.state = ''ACTIVE''
		)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		(
			case
				when uuld is not null then ''Yes''
				else ''No''
			end
		) as "appInstalled"
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		inner join um_user_login_det uuld on enrolled_data.user_id = uuld.user_id
	where uu.state = ''ACTIVE''
	limit #limit# offset #offset#',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_registered_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c0cb39e2-dbfe-43d5-9302-61d616e39bad', 97070,  current_date , 97070,  current_date , 'lms_dashboard_retrieve_total_registered_members',
'offset,locationId,limit',
'with training_ids as (
	select distinct training_id
	from tr_training_course_rel
	where course_id in (
			select course_id
			from tr_course_master
			where course_state = ''ACTIVE''
				and course_type = ''ONLINE''
		)
),
enrolled_users as (
	select distinct attendee_id as enrolled_user_id
	from tr_training_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_attendee_rel.training_id
	union
	select distinct additional_attendee_id as enrolled_user_id
	from tr_training_additional_attendee_rel
		inner join training_ids on training_ids.training_id = tr_training_additional_attendee_rel.training_id
),
location_users as (
	select distinct user_id
	from location_hierchy_closer_det
		inner join um_user_location on um_user_location.loc_id = location_hierchy_closer_det.child_id
		and um_user_location.state = ''ACTIVE''
		inner join enrolled_users on enrolled_users.enrolled_user_id = um_user_location.user_id
	where (
			case
				when #locationId# is null then parent_id in (
				select id
				from location_master
				where type = ''S''
			)
			else parent_id = #locationId# end)
		),
		enrolled_data as (
			select distinct location_users.user_id
			from location_users
				inner join um_user on location_users.user_id = um_user.id
				and um_user.state = ''ACTIVE''
		)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		(
			case
				when uuld is not null then ''Yes''
				else ''No''
			end
		) as "appInstalled"
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		left join um_user_login_det uuld on enrolled_data.user_id = uuld.user_id
	where uu.state = ''ACTIVE''
	limit #limit# offset #offset#',
null,
true, 'ACTIVE');