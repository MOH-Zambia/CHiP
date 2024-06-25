DELETE FROM QUERY_MASTER WHERE CODE='retrieve_covid_19_travellers_count';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_covid_19_travellers_count',
'locationId,isFromImmigration',
'
    select
    count(*) as "totalCount",
    count(*) FILTER (WHERE location_id is null) as "pendingCount",
    count(*) FILTER (WHERE location_id is not null) as "completedCount",
    (select name from location_master where id = #locationId#) as "locationName"
    from covid_travellers_info cti
    where cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
    and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
    and (cti.input_type = ''Travel'' or cti.is_from_immigration is true)
',
'Retrieve COVID 19 Travellers Count',
true, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_covid_19_travellers';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'retrieve_covid_19_travellers',
'retrieveNonContactable,offset,locationId,limit,retrievePending,isFromImmigration',
'with "filteredTravellers" as (
        select
        cti.*
        from covid_travellers_info cti
        where
        (case
            when #retrievePending# is true then cti.location_id is null
            when #retrieveNonContactable# is true then cti.is_update_location is true
            else cti.location_id is not null
        end)
        and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
        and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
        and (cti.input_type = ''Travel'' or cti.is_from_immigration is true)
        order by
            case
                when (cti.health_status is null or TRIM(BOTH FROM cti.health_status) = '''' or TRIM(BOTH FROM cti.health_status) = ''-'') then 3
                when (TRIM(BOTH FROM cti.health_status) ilike ''normal'') then 2
                else 1
            end asc
        limit #limit# offset #offset#
    ),
    "lastScreeningDates" as (
        select
        ctsi.covid_info_id as id,
        max(ctsi.created_on) as "lastScreeningDate"
        from "filteredTravellers" ft
        inner join covid_travellers_screening_info ctsi on ctsi.covid_info_id = ft.id
        group by ctsi.covid_info_id
    )
    select
    ft.*,
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "fullName",
    im.unique_health_id as "uniqueHealthId",
    im.family_id as "familyId",
    im.mobile_number as "mobileNumber",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    get_location_hierarchy(ft.district_id) as "districtHierarchy",
    lsd."lastScreeningDate"
    from "filteredTravellers" ft
    left join imt_member im on im.id = ft.member_id
    left join imt_family if on im.family_id = if.family_id
    left join "lastScreeningDates" lsd on lsd.id = ft.id
    order by
        case
            when (ft.health_status is null or TRIM(BOTH FROM ft.health_status) = '''' or TRIM(BOTH FROM ft.health_status) = ''-'') then 3
            when (TRIM(BOTH FROM ft.health_status) ilike ''normal'') then 2
            else 1
        end asc',
'Retrieve COVID 19 Travellers',
true, 'ACTIVE');