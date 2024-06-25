
-- opd_search_referred_travellers_covid_19_by_location_id

delete from query_master where code='opd_search_referred_travellers_covid_19_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_referred_travellers_covid_19_by_location_id', 'offSet,locationId,limit', '
    with  maxScreeningId as (
        select
        max(ctsi.id) as id,
        ctsi.covid_info_id as "covidInfoId"
        from covid_travellers_info cti
        inner join covid_travellers_screening_info ctsi on ctsi.covid_info_id = cti.id
        where ctsi.any_symptoms and ctsi.referral_required
        and cti.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
        group by covid_info_id
    )
    select
    cti.id,
    cti.name,
    cti.address,
    cti.pincode,
    cti.location_id as "locationId",
    cti.member_id as "memberId",
    ctsi.symptoms,
    ctsi.other_symptoms as "otherSymptoms"
    from covid_travellers_info cti
    inner join covid_travellers_screening_info ctsi on ctsi.id = (select id from maxScreeningId msi where msi."covidInfoId" = cti.id)
    where cti.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    limit #limit# offset #offSet#;
', true, 'ACTIVE', 'OPD Search IDSP Referred Patients By Location ID');
