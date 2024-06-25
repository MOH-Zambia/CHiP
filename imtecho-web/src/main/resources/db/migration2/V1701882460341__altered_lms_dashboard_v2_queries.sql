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
		),
		district_name as (
			select lm.name as "district",
				enrolled_users.enrolled_user_id
			from enrolled_users
				inner join um_user_location uul on uul.user_id = enrolled_users.enrolled_user_id
				and uul.state = ''ACTIVE''
				inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
				and lhcd.parent_loc_type = ''D''
				inner join location_master lm on lhcd.parent_id = lm.id
		)
	select DISTINCT uu.id,
		concat(uu.first_name, '' '', uu.last_name) as "participantName",
		uu.user_name as "userName",
		urm.name as "roleName",
		district_name.district as "district",
		(
			case
				when uuld.id is not null then ''Yes''
				else ''No''
			end
		) as "appInstalled"
	from enrolled_data
		inner join um_user uu on enrolled_data.user_id = uu.id
		inner join um_role_master urm on urm.id = uu.role_id
		left join um_user_login_det uuld on uu.id = uuld.user_id
		inner join district_name on district_name.enrolled_user_id = enrolled_data.user_id
	where uu.state = ''ACTIVE''
	limit #limit# offset #offset#',
null,
true, 'ACTIVE');