/*alter table mytecho_covid_symptom_checker_dump
drop column if exists member_id,
add column member_id integer,
drop column if exists location_id,
add column location_id integer;*/



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