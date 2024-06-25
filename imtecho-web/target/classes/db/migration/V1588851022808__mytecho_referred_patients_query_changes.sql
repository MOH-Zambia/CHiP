DELETE FROM QUERY_MASTER WHERE CODE='opd_search_mytecho_referred_patients_by_location_id';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'opd_search_mytecho_referred_patients_by_location_id',
'offSet,limit,locationId',
'
    with top_filtered_members as (
        select
        mytecho_dump.mt_member_id,
        max(mytecho_dump.id) as id
        from mytecho_covid_symptom_checker_dump mytecho_dump
        left join rch_opd_member_registration romr on mytecho_dump.member_id = romr.member_id and romr.reference_type = ''MYTECHO_REF''
        where
        mytecho_dump.member_id is not null
        and romr.id is null
        and (
            cast(cast(mytecho_dump.data as json) -> ''fever'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''cough'' as text) = ''true''
            or cast(cast(mytecho_dump.data as json) -> ''shortOfBreath'' as text) = ''true''
        )
        and mytecho_dump.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        group by mytecho_dump.mt_member_id
        order by mytecho_dump.mt_member_id
        limit #limit# offset #offSet#
    )
    select
    mytecho_dump.id as "mtCovidSymptomCheckerId",
    mytecho_dump.member_id as "memberId",
    mytecho_dump.mt_member_id as "mtMemberId",
    mytecho_dump.name as "name",
    mytecho_dump.mobile_number as "mobileNumber",
    mytecho_dump.location_id as "locationId",
    get_location_hierarchy(mytecho_dump.location_id) as "locationHierarchy",
    imt_member.unique_health_id as "uniqueHealthId",
    imt_member.family_id as "familyId",
    imt_member.dob as "dob",
    cast(age(imt_member.dob) as text) as "age"
    from top_filtered_members
    inner join mytecho_covid_symptom_checker_dump mytecho_dump on top_filtered_members.id = mytecho_dump.id
    inner join imt_member on imt_member.id = mytecho_dump.member_id
    inner join imt_family on imt_member.family_id = imt_family.family_id;
',
'OPD Search MyTeCHO Referred Patients By Location ID',
true, 'ACTIVE');

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
        left join rch_opd_member_registration romr on mytecho_dump.member_id = romr.member_id and romr.reference_type = ''MYTECHO_REF''
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