
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