
-- retrieve_covid_19_travellers_count

delete from query_master where code='retrieve_covid_19_travellers_count';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_covid_19_travellers_count', 'locationId', '
    select
    count(*) as "totalCount",
    count(*) FILTER (WHERE location_id is null) as "pendingCount",
    count(*) FILTER (WHERE location_id is not null) as "completedCount"
    from covid_travellers_info cti
    where cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
', true, 'ACTIVE', 'Retrieve COVID 19 Travellers Count');

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
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#
', true, 'ACTIVE', 'OPD Search IDSP Referred Patients By Location ID');

