DELETE FROM QUERY_MASTER WHERE CODE='update_location_of_covid_19_traveller';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_location_of_covid_19_traveller',
'id,locationId,address,isOutOfState,districtId,loggedInUserId',
'

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    is_active = true,
    tracking_start_date = now(),
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

',
'Update Location of COVID 19 Traveller',
false, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='update_location_and_create_imt_member_of_covid_19_traveller';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_location_and_create_imt_member_of_covid_19_traveller',
'id,locationId,address,isOutOfState,loggedInUserId,firstName,dob',
'

    begin;

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    is_active = true,
    tracking_start_date = now(),
    modified_on = now(),
    modified_by = #loggedInUserId#
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
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id > 0 and location_id is not null;

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

',
'Update Location and Insert Imt Member/Family of COVID 19 Traveller',
false, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='update_location_of_covid_19_non_contactable_traveller';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_location_of_covid_19_non_contactable_traveller',
'id,locationId,address,isOutOfState,districtId,loggedInUserId',
'

     begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    is_active = true,
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

',
'Update Location of COVID 19 Non-Contactable Traveller',
false, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='update_location_and_create_imt_member_of_covid_19_non_contactable_traveller';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_location_and_create_imt_member_of_covid_19_non_contactable_traveller',
'id,locationId,address,isOutOfState,loggedInUserId,dob',
'

    begin;

    -- update location

    update covid_travellers_info
    set previous_location = location_id,
    location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    is_active = true,
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

',
'Update Location and Create IMT Member/Family of COVID 19 Non-Contactable Traveller',
false, 'ACTIVE');

--

DELETE FROM QUERY_MASTER WHERE CODE='update_location_not_found_of_covid_19_traveller';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'update_location_not_found_of_covid_19_traveller',
'id,reason,loggedInUserId',
'

    begin;

    -- update location

    update covid_travellers_info
    set location_id = -1,
    is_update_location = false,
    update_location_reason = ''OTHER'',
    other_update_location_reason = ''#reason#'',
    update_location_source_type = ''WEB'',
    is_active = false,
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

    -- delete existing notifications

    delete from public.techo_notification_master
    where notification_type_id = (select id from notification_type_master where name = ''Travellers Screening Alert'')
    and member_id = #id#;

    commit;

',
'Update Location Not Found of COVID 19 Non-Contactable Traveller',
false, 'ACTIVE');