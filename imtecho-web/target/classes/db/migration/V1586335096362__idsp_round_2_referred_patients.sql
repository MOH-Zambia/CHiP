/*
-- old stagging query for reference

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_idsp_referred_patients_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_idsp_referred_patients_by_location_id',
'offSet,locationId,limit',
'
    select
    imsd.id as "idspMemberScreeningId",
    imt_member.id as "memberId",
    imt_member.unique_health_id as "uniqueHealthId",
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
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id
    and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE''
    and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF''
    where romr.id is null
    and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    and (imsd.travel_detail is not null and imsd.travel_detail not in (''NO_TRAVEL''))
    and (imsd.is_cough or imsd.is_fever or imsd.covid_symptoms ilike ''%breathlessness%'')
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#;
',
'OPD Search IDSP Referred Patients By Location ID',
true, 'ACTIVE');
*/

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_idsp_referred_patients_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_idsp_referred_patients_by_location_id',
'offSet,locationId,limit',
'
    with idsp_det as(
        select
        imsd.*
        from idsp_member_screening_details imsd
        left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF''
        where
        romr.id is null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and (imsd.travel_detail is not null and imsd.travel_detail not in (''NO_TRAVEL''))
        and (imsd.is_cough or imsd.is_fever or imsd.covid_symptoms ilike ''%breathlessness%'')
        limit #limit# offset #offSet#
    )
    select
    imsd.id as "idspMemberScreeningId",
    1 as "idspRound",
    imt_member.id as "memberId",
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.family_id as "familyId",
    imt_member.mobile_number as "mobileNumber",
    imt_family.location_id as "locationId",
    get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from
    idsp_det imsd
    inner join imt_member on imt_member.id = imsd.member_id
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id;
',
'OPD Search IDSP Referred Patients By Location ID',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='opd_search_idsp_2_referred_patients_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_idsp_2_referred_patients_by_location_id',
'offSet,locationId,limit',
'
    with idsp_det as(
        select
        imsd.*
        from idsp_2_member_screening_details imsd
        left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF_2''
        where
        romr.id is null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 1
        limit #limit# offset #offSet#
    )
    select
    imsd.id as "idspMemberScreeningId",
    2 as "idspRound",
    imt_member.id as "memberId",
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.family_id as "familyId",
    imt_member.mobile_number as "mobileNumber",
    imt_family.location_id as "locationId",
    get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
    concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age",
    concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
    uu1.contact_number as "ashaContactNumber",
    uu1.techo_phone_number as "ashaTechoContactNumber",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
    uu2.contact_number as "anmContactNumber",
    uu2.techo_phone_number as "anmTechoContactNumber"
    from
    idsp_det imsd
    inner join imt_member on imt_member.id = imsd.member_id
    inner join imt_family on imt_member.family_id = imt_family.family_id
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id;
',
'OPD Search IDSP 2 Referred Patients By Location ID',
true, 'ACTIVE');