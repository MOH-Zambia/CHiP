
-- opd_search_by_member_id

delete from query_master where code='opd_search_by_member_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_member_id', 'uniqueHealthId,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.area_id as "areaId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.unique_health_id in (''#uniqueHealthId#'')
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Member ID');


-- opd_search_by_family_id

delete from query_master where code='opd_search_by_family_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_family_id', 'familyId,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.family_id in (''#familyId#'')
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Family ID');


-- opd_search_by_location_id

delete from query_master where code='opd_search_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_location_id', 'offSet,locationId,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Location ID');


-- opd_search_by_mobile_number

delete from query_master where code='opd_search_by_mobile_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_mobile_number', 'offSet,mobileNumber,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.mobile_number = ''#mobileNumber#''
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Mobile Number');


-- opd_search_by_pmjay_number

delete from query_master where code='opd_search_by_pmjay_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_pmjay_number', 'pmjayNumber,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_member_cfhc_master on imt_member.id = imt_member_cfhc_master.member_id
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member_cfhc_master.pmjay_number = ''#pmjayNumber#''
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By PMJAY Number');


-- opd_search_by_ration_number

delete from query_master where code='opd_search_by_ration_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_ration_number', 'rationNumber,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.ration_card_number = ''#rationNumber#''
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By Ration Number');


-- opd_search_by_maa_vatsalya_number

delete from query_master where code='opd_search_by_maa_vatsalya_number';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_maa_vatsalya_number', 'maavatsalyaNumber,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_family.maa_vatsalya_number = ''#maavatsalyaNumber#''
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By MAA Vatsalya Number');


-- opd_search_by_dob

delete from query_master where code='opd_search_by_dob';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_dob', 'dob,offSet,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_family.family_id as "familyId",
   imt_family.location_id as "locationId",
   imt_member.mobile_number as "mobileNumber",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from imt_member
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imt_member.dob = cast(''#dob#'' as date)
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search By DOB');


-- opd_search_idsp_referred_patients_by_location_id

delete from query_master where code='opd_search_idsp_referred_patients_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_idsp_referred_patients_by_location_id', 'offSet,locationId,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_member.family_id as "familyId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.location_id as "locationId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from idsp_member_screening_details imsd
   inner join imt_member on imt_member.id = imsd.member_id
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
   and imsd.is_fever is true and imsd.is_cough is true
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search IDSP Referred Patients By Location ID');


-- opd_search_by_opd_member_registration_id

delete from query_master where code='opd_search_by_opd_member_registration_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_opd_member_registration_id', 'opdMemberRegistrationId,userId', '
   with maxDeliveryDateOfMember as (
		select
		rwmm.member_id,
		max(rwmm.date_of_delivery) as max_delivery_date
		from
		rch_wpd_mother_master rwmm
		where
		rwmm.member_id in (select member_id from rch_opd_member_registration where id = #opdMemberRegistrationId#)
		and rwmm.has_delivery_happened is true
		group by rwmm.member_id
	)
   select
   im.id as "memberId",
   im.unique_health_id as "uniqueHealthId",
   if.family_id as "familyId",
   im.mobile_number as "mobileNumber",
   concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
   im.dob as "dob",
   cast(age(im.dob) as text) as "age",
   if.location_id as "locationId",
   if.area_id as "areaId",
   get_location_hierarchy(if.location_id) as "locationHierarchy",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber",
   im.is_pregnant as "isPregnant",
   cast(mddom.max_delivery_date as date) as "lastDeliveryDate",
   case
		when mddom.max_delivery_date is null then false
		when current_date - cast(mddom.max_delivery_date as date) <= 45 then true
		else false
	end as "hasDeliveryHappenedInLast45Days",
	case
		when nmdd1.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd1.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd1.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "hypertensionStatus",
	case
		when nmdd2.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd2.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd2.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "diabetesStatus",
	romr.health_infra_id as "healthInfraId",
	hid.name as "healthInfraName",
	hid."type" as "healthInfraType"
	from rch_opd_member_registration romr
   inner join  imt_member im on romr.member_id = im.id
   inner join imt_family if on im.family_id = if.family_id
   left join um_user_location uul1 on uul1.loc_id = if.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = if.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   left join maxDeliveryDateOfMember mddom on mddom.member_id = im.id
   left join ncd_member_diseases_diagnosis nmdd1 on nmdd1.member_id = im.id and nmdd1.disease_code = ''HT''
   left join ncd_member_diseases_diagnosis nmdd2 on nmdd2.member_id = im.id and nmdd2.disease_code = ''D''
   left join health_infrastructure_details hid on hid.id = romr.health_infra_id
   where romr.id = #opdMemberRegistrationId#
   and cast(romr.registration_date as date) = current_date
   and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
', true, 'ACTIVE', 'OPD Search By OPD Member Registration ID');


-- opd_search_by_opd_member_master_id

delete from query_master where code='opd_search_by_opd_member_master_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_by_opd_member_master_id', 'opdMemberMasterId,userId', '
   with maxDeliveryDateOfMember as (
		select
		rwmm.member_id,
		max(rwmm.date_of_delivery) as max_delivery_date
		from
		rch_wpd_mother_master rwmm
		where
		rwmm.member_id in (select member_id from rch_opd_member_master where id = #opdMemberMasterId#)
		and rwmm.has_delivery_happened is true
		group by rwmm.member_id
	)
   select
   im.id as "memberId",
   im.mobile_number as "mobileNumber",
   im.unique_health_id as "uniqueHealthId",
   if.family_id as "familyId",
   concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
   im.dob as "dob",
   cast(age(im.dob) as text) as "age",
   if.location_id as "locationId",
   if.area_id as "areaId",
   get_location_hierarchy(if.location_id) as "locationHierarchy",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber",
   im.is_pregnant as "isPregnant",
   cast(mddom.max_delivery_date as date) as "lastDeliveryDate",
   case
		when mddom.max_delivery_date is null then false
		when current_date - cast(mddom.max_delivery_date as date) <= 45 then true
		else false
	end as "hasDeliveryHappenedInLast45Days",
	case
		when nmdd1.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd1.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd1.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "hypertensionStatus",
	case
		when nmdd2.status = ''NO_ABNORMALITY'' then ''No Abnormality''
		when nmdd2.status = ''TREATMENT_STARTED'' then ''Positive and Treatment Started''
		when nmdd2.status in (''CONFIRMED'', ''REFERRED'') then ''Positive''
		else ''N/A''
	end as "diabetesStatus",
   romm.service_date as "serviceDate",
   romm.medicines_given_on as "medicinesGivenOn",
   hid."name" as "healthInfraName",
   (
   	select
   	string_agg(
   		roltm.name, '', ''
		)
	    from rch_opd_lab_test_master roltm
	    inner join rch_opd_lab_test_details roltd on roltd.lab_test_id = roltm.id
	    where roltd.opd_member_master_id = romm.id
   ) as "labTests",
   (
   	select
   	string_agg(
   		lfvd.value, '', ''
		)
	    from listvalue_field_value_detail lfvd
	    inner join rch_opd_lab_test_provisional_rel roltpr on roltpr.opd_member_master_id = romm.id
	    where lfvd.id = roltpr.provisional_id
   ) as "provisionalDiagnosis",
   (
   	select
   	cast(
           json_agg(
               json_build_object(
                   ''id'', roed.id,
                   ''memberId'', roed.member_id,
                   ''opdMemberMasterId'', roed.opd_member_master_id,
                   ''edlId'', roed.edl_id,
                   ''frequency'', cast(roed.frequency as text),
                   ''quantityBeforeFood'', cast(roed.quantity_before_food as text),
                   ''quantityAfterFood'', cast(roed.quantity_after_food as text),
                   ''numberOfDays'', cast(roed.number_of_days as text),
                   ''createdBy'', roed.created_by,
                   ''createdOn'', roed.created_on
               )
		    )
		as text)
	    from rch_opd_edl_details roed
	    where roed.opd_member_master_id = romm.id
   ) as "opdEdlDetails"
	from rch_opd_member_master romm
   inner join imt_member im on romm.member_id = im.id
   inner join imt_family if on im.family_id = if.family_id
   left join um_user_location uul1 on uul1.loc_id = if.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = if.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   left join maxDeliveryDateOfMember mddom on mddom.member_id = im.id
   left join ncd_member_diseases_diagnosis nmdd1 on nmdd1.member_id = im.id and nmdd1.disease_code = ''HT''
   left join ncd_member_diseases_diagnosis nmdd2 on nmdd2.member_id = im.id and nmdd2.disease_code = ''D''
   left join health_infrastructure_details hid on hid.id = romm.health_infra_id
   where romm.id = #opdMemberMasterId#
   and cast(romm.medicines_given_on as date) = current_date
   and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
', true, 'ACTIVE', 'OPD Search By OPD Member Master ID');
