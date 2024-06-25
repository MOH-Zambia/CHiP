
-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/-/issues/3618

-- here is old query of OPD - IDSP 2 Referred Patients (search and count) for reference

/*
DELETE FROM QUERY_MASTER WHERE CODE='opd_search_referred_patients_counts_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_referred_patients_counts_by_location_id',
'locationId',
'
    with idsp_referred_patients_count as (
        select
        count(1) as count
        from idsp_member_screening_details imsd
        left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF''
        where
        romr.id is null
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and (imsd.travel_detail is not null and imsd.travel_detail not in (''NO_TRAVEL''))
        and (imsd.is_cough or imsd.is_fever or imsd.covid_symptoms ilike ''%breathlessness%'')
    ),
    idsp_2_referred_patients_count as (
        select
        count(1) as count
        from idsp_2_member_screening_details imsd
        left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF_2''
        where
        romr.id is null
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
    ),
    mytecho_referred_patients_count as (
        select
        count(distinct mytecho_dump.mt_member_id) as count
        from mytecho_covid_symptom_checker_dump mytecho_dump
        left join rch_opd_member_registration romr on mytecho_dump.id = romr.reference_id and romr.reference_type = ''MYTECHO_REF''
        where
        mytecho_dump.member_id is not null
        and romr.id is null
        and (
            cast(cast(mytecho_dump.data as json) -> ''fever'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''cough'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''shortOfBreath'' as text) = ''true''
        )
        and mytecho_dump.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    ),
    covid_19_referred_travellers_max_screening_id as (
        select
        max(ctsi.id) as id,
        ctsi.covid_info_id as "covidInfoId"
        from covid_travellers_info cti
        inner join covid_travellers_screening_info ctsi on ctsi.covid_info_id = cti.id
        where ctsi.any_symptoms and ctsi.referral_required
        and cti.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        group by covid_info_id
    ),
    covid_19_referred_travellers_count as (
        select
        count(1) as count
        from covid_travellers_info cti
        inner join covid_travellers_screening_info ctsi on ctsi.id = (select id from covid_19_referred_travellers_max_screening_id msi where msi."covidInfoId" = cti.id)
        left join rch_opd_member_registration romr on ctsi.id = romr.reference_id and romr.reference_type = ''COVID_TRAVELLERS_SCREENING''
        where romr.id is null
    )
    select
    (select count from idsp_referred_patients_count) as "idspReferredPatientsCount",
    (select count from idsp_2_referred_patients_count) as "idsp2ReferredPatientsCount",
    (select count from mytecho_referred_patients_count) as "mytechoReferredPatientsCount",
    (select count from covid_19_referred_travellers_count) as "covid19ReferredTravellersCount";
',
'OPD Search Referred Patients Counts By Location ID',
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
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
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
*/


-- and here is new query of OPD - IDSP 2 Referred Patients (search and count)

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_referred_patients_counts_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_referred_patients_counts_by_location_id',
'locationId',
'
    with idsp_referred_patients_count as (
        select
        count(1) as count
        from idsp_member_screening_details imsd
        left join rch_opd_member_registration romr on imsd.id = romr.reference_id and romr.reference_type = ''IDSP_REF''
        where
        romr.id is null
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and (imsd.travel_detail is not null and imsd.travel_detail not in (''NO_TRAVEL''))
        and (imsd.is_cough or imsd.is_fever or imsd.covid_symptoms ilike ''%breathlessness%'')
    ),
    latest_opd_registration as (
        select
        romr.member_id,
        max(romr.created_on) as max_created_on
        from rch_opd_member_registration romr
        inner join idsp_2_member_screening_details imsd on imsd.member_id = romr.member_id
        where romr.reference_type = ''IDSP_REF_2''
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
        group by romr.member_id
    ),
    latest_idsp_screening as (
        select
        imsd.member_id,
        max(imsd.id) as max_id
        from idsp_2_member_screening_details imsd
        where imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
        group by imsd.member_id
    ),
    idsp_2_referred_patients_count as (
        select
        count(1) as count
        from latest_idsp_screening lis
        inner join idsp_2_member_screening_details imsd on imsd.id = lis.max_id
        left join latest_opd_registration lor on lor.member_id = imsd.member_id and lor.max_created_on >= imsd.created_on
        where lor.member_id is null
    ),
    mytecho_referred_patients_count as (
        select
        count(distinct mytecho_dump.mt_member_id) as count
        from mytecho_covid_symptom_checker_dump mytecho_dump
        left join rch_opd_member_registration romr on mytecho_dump.id = romr.reference_id and romr.reference_type = ''MYTECHO_REF''
        where
        mytecho_dump.member_id is not null
        and romr.id is null
        and (
            cast(cast(mytecho_dump.data as json) -> ''fever'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''cough'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''shortOfBreath'' as text) = ''true''
        )
        and mytecho_dump.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    ),
    covid_19_referred_travellers_max_screening_id as (
        select
        max(ctsi.id) as id,
        ctsi.covid_info_id as "covidInfoId"
        from covid_travellers_info cti
        inner join covid_travellers_screening_info ctsi on ctsi.covid_info_id = cti.id
        where ctsi.any_symptoms and ctsi.referral_required
        and cti.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        group by covid_info_id
    ),
    covid_19_referred_travellers_count as (
        select
        count(1) as count
        from covid_travellers_info cti
        inner join covid_travellers_screening_info ctsi on ctsi.id = (select id from covid_19_referred_travellers_max_screening_id msi where msi."covidInfoId" = cti.id)
        left join rch_opd_member_registration romr on ctsi.id = romr.reference_id and romr.reference_type = ''COVID_TRAVELLERS_SCREENING''
        where romr.id is null
    )
    select
    (select count from idsp_referred_patients_count) as "idspReferredPatientsCount",
    (select count from idsp_2_referred_patients_count) as "idsp2ReferredPatientsCount",
    (select count from mytecho_referred_patients_count) as "mytechoReferredPatientsCount",
    (select count from covid_19_referred_travellers_count) as "covid19ReferredTravellersCount";
',
'OPD Search Referred Patients Counts By Location ID',
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='opd_search_idsp_2_referred_patients_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_idsp_2_referred_patients_by_location_id',
'offSet,locationId,limit',
'
    with latest_opd_registration as (
        select
        romr.member_id,
        max(romr.created_on) as max_created_on
        from rch_opd_member_registration romr
        inner join idsp_2_member_screening_details imsd on imsd.member_id = romr.member_id
        where romr.reference_type = ''IDSP_REF_2''
        and imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
        group by romr.member_id
    ),
    latest_idsp_screening as (
        select
        imsd.member_id,
        max(imsd.id) as max_id
        from idsp_2_member_screening_details imsd
        where imsd.member_id is not null
        and imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        and imsd.treatment_started = 0
        group by imsd.member_id
    ),
    idsp_det as (
        select
        imsd.*
        from latest_idsp_screening lis
        inner join idsp_2_member_screening_details imsd on imsd.id = lis.max_id
        left join latest_opd_registration lor on lor.member_id = imsd.member_id and lor.max_created_on >= imsd.created_on
        where lor.member_id is null
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
