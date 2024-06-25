
-- update_location_of_covid_19_traveller

delete from query_master where code='update_location_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_of_covid_19_traveller', 'id,locationId,address,isOutOfState,districtId', '

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    tracking_start_date = now()
    where id = #id#;

    -- create notification

    INSERT INTO public.techo_notification_master (
        notification_type_id, notification_code, location_id,
        member_id, schedule_date, expiry_date,
        state, created_by, created_on, modified_by, modified_on
    )
    select (select id from notification_type_master where name = ''Travellers Screening Alert''),
    row_number() OVER () as rnum, location_id, id,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as sched_date,
    cast(ct.tracking_start_date as date) + interval ''1 days'' * (row_number() OVER () - 1) as exp_date, ''PENDING'',
    ''-1'', now(), ''-1'', now() from covid_travellers_info ct
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id != -2 and location_id is not null;

', false, 'ACTIVE', 'Update Location of COVID 19 Traveller');

--deleting these first 2 queries as no need of use (making generic as to handle both difficult)
delete from query_master where code='retrieve_pending_covid_19_travellers';
delete from query_master where code='retrieve_updated_covid_19_travellers';

-- retrieve_covid_19_travellers
delete from query_master where code='retrieve_covid_19_travellers';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_covid_19_travellers', 'limit,offset,locationId,isFromImmigration,retrievePending', '
    with "filteredTravellers" as (
        select
        cti.*
        from covid_travellers_info cti
        where
        (case
            when #retrievePending# is true then cti.location_id is null
            else cti.location_id is not null
        end)
        and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
        and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
        order by
            case
                when (cti.health_status is null or health_status = '''') then 3
                when (cti.health_status ilike ''%normal%'') then 2
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

', true, 'ACTIVE', 'Retrieve COVID 19 Travellers');

