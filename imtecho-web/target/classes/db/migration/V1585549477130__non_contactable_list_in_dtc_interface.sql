
-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3463

-- retrieve_covid_19_travellers

delete from query_master where code='retrieve_covid_19_travellers';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_covid_19_travellers', 'limit,offset,locationId,isFromImmigration,retrievePending,retrieveNonContactable', '
    with "filteredTravellers" as (
        select
        cti.*
        from covid_travellers_info cti
        where
        (case
            when #retrievePending# is true then cti.location_id is null
            when #retrieveNonContactable# is true then cti.is_update_location is false
            else cti.location_id is not null
        end)
        and cti.district_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
        and (cti.is_from_immigration = #isFromImmigration# or false = #isFromImmigration#)
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
        end asc

', true, 'ACTIVE', 'Retrieve COVID 19 Travellers');

-- update_location_of_covid_19_non_contactable_traveller

delete from query_master where code='update_location_of_covid_19_non_contactable_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_of_covid_19_non_contactable_traveller', 'id,locationId,address,isOutOfState,districtId,loggedInUserId', '

     begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    tracking_start_date = now(),
    is_update_location = false,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from public.techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    commit;

', false, 'ACTIVE', 'Update Location of COVID 19 Non-Contactable Traveller');

-- update_location_and_create_imt_member_of_covid_19_non_contactable_traveller

delete from query_master where code='update_location_and_create_imt_member_of_covid_19_non_contactable_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_and_create_imt_member_of_covid_19_non_contactable_traveller', 'id,locationId,address,isOutOfState,loggedInUserId,dob', '

    begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    tracking_start_date = now(),
    is_update_location = true,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from public.techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    -- create new notifications

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
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id is not null and location_id > 0;

    -- create record of imt_member and imt_family

    with get_asha_area_id as (
        select
        case
            when parent_loc_type in (''A'',''AA'') then parent_id
            when parent_loc_type in (''V'',''ANG'') then child_id
        end as location_id
        from location_hierchy_closer_det
        where parent_id = ''#locationId#''
        limit 1
    ),
    insert_imt_family as (
        INSERT INTO public.imt_family (address1, area_id, caste, created_on, family_id, religion, location_id, state, basic_state, created_by, modified_by, modified_on)
        select
        ''#address#'' as address, (select location_id from get_asha_area_id) as area_id, ''627'' as caste, now() as created_on, ''FM/'' || date_part(''YEAR'', NOW()) || ''/'' || nextval(''family_id_seq'') || ''N'' as family_id,
        ''640'' as religion, (select case when type in (''A'',''AA'') then parent else id end from location_master where id = #locationId#) as location_id,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, ''#loggedInUserId#'', ''#loggedInUserId#'', now()
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning family_id
    ),
    insert_imt_member as (
        INSERT INTO public.imt_member(unique_health_id, first_name, dob, gender, state, basic_state, created_by, created_on, modified_by, modified_on, family_head, family_id)
        select ''A'' || nextval(''member_unique_health_id_seq'') || ''N'' as unique_health_id, cti.name as first_name, ''#dob#'' as dob,
        case
            when cti.gender ilike ''m'' or cti.gender ilike ''male'' then ''M''
            when cti.gender ilike ''f'' or cti.gender ilike ''female'' then ''F''
            else ''OTHER''
        end as gender,
        case
            when cti.input_type = ''DR_TECHO'' then ''IDSP_DR_TECHO''
            when cti.input_type = ''MY_TECHO'' then ''IDSP_MY_TECHO''
            else ''IDSP_TECHO''
        end as state, ''IDSP'' as basic_state, ''#loggedInUserId#'', now(), ''#loggedInUserId#'', now(), true, (select family_id from insert_imt_family)
        from covid_travellers_info cti
        where cti.id = #id# and cti.member_id is null
        returning id
    ),
    update_covid_travellers_info as (
        update covid_travellers_info
        set member_id = (select id from insert_imt_member)
        where id = #id# and member_id is null
    )
    update
    imt_family
    set hof_id  = (select id from insert_imt_member)
    where family_id = (select family_id from insert_imt_family);

    commit;

', false, 'ACTIVE', 'Update Location and Create IMT Member/Family of COVID 19 Non-Contactable Traveller');

-- update_location_not_found_of_covid_19_traveller

delete from query_master where code='update_location_not_found_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_not_found_of_covid_19_traveller', 'id,reason,loggedInUserId', '

    begin;

    -- update location

    update covid_travellers_info
    set location_id = -1,
    is_update_location = false,
    update_location_reason = ''OTHER'',
    other_update_location_reason = ''#reason#'',
    update_location_source_type = ''WEB'',
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from public.techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    commit;

', false, 'ACTIVE', 'Update Location Not Found of COVID 19 Non-Contactable Traveller');


-- add columns in covid_travellers_info

alter table covid_travellers_info
drop column if exists update_location_source_type,
add column update_location_source_type varchar(50);