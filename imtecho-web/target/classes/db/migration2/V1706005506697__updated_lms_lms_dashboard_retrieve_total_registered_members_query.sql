DELETE FROM QUERY_MASTER WHERE CODE='lms_dashboard_retrieve_total_registered_members';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'c0cb39e2-dbfe-43d5-9302-61d616e39bad', 97157,  current_date , 97157,  current_date , 'lms_dashboard_retrieve_total_registered_members',
'offset,locationId,limit,loggedInUserId',
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
				select loc_id
				from um_user_location
				where state = ''ACTIVE''
					and user_id = #loggedInUserId#
			)
			else parent_id in (
				#locationId#) end)
			),
			enrolled_data as (
				select distinct location_users.user_id
				from location_users
					inner join um_user on location_users.user_id = um_user.id
					and um_user.state = ''ACTIVE''
			),
			loc_name as (
				select lm.name as name,
					enrolled_users.enrolled_user_id,
					lhcd.parent_loc_type
				from enrolled_users
					inner join um_user_location uul on uul.user_id = enrolled_users.enrolled_user_id
					and uul.state = ''ACTIVE''
					inner join location_hierchy_closer_det lhcd on lhcd.child_id = uul.loc_id
					inner join location_master lm on lhcd.parent_id = lm.id
			)
			select DISTINCT uu.id,
				concat(uu.first_name, '' '', uu.last_name) as "participantName",
				uu.user_name as "userName",
				urm.name as "roleName",
				uu.contact_number as "contactNumber",
				district_name.name as "district",
				div_name.name as "division",
				mandal_name.name as "mandal",
				phc_name.name as "phc",
				sc_name.name as "sc",
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
				left join loc_name as district_name on district_name.enrolled_user_id = enrolled_data.user_id
				and district_name.parent_loc_type = ''D''
				left join loc_name as div_name on div_name.enrolled_user_id = enrolled_data.user_id
				and div_name.parent_loc_type = ''DIV''
				left join loc_name as mandal_name on mandal_name.enrolled_user_id = enrolled_data.user_id
				and mandal_name.parent_loc_type = ''M''
				left join loc_name as phc_name on phc_name.enrolled_user_id = enrolled_data.user_id
				and phc_name.parent_loc_type = ''PHC''
				left join loc_name as sc_name on sc_name.enrolled_user_id = enrolled_data.user_id
				and sc_name.parent_loc_type = ''SC''
			where uu.state = ''ACTIVE''
			limit #limit# offset #offset#',
null,
true, 'ACTIVE');