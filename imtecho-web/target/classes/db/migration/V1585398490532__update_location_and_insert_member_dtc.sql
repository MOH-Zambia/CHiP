
-- update_location_of_covid_19_traveller

delete from query_master where code='update_location_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_of_covid_19_traveller', 'id,locationId,address,isOutOfState,districtId,loggedInUserId', '

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
    district_id = #districtId#,
    tracking_start_date = now(),
    modified_on = now(),
    modified_by = #loggedInUserId#
    where id = #id#;

', false, 'ACTIVE', 'Update Location of COVID 19 Traveller');


-- update_location_and_create_imt_member_of_covid_19_traveller

delete from query_master where code='update_location_and_create_imt_member_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_and_create_imt_member_of_covid_19_traveller', 'id,locationId,address,isOutOfState,loggedInUserId,firstName,dob', '

    begin;

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
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

', false, 'ACTIVE', 'Update Location and Insert Imt Member/Family of COVID 19 Traveller');


-- migration

--DO
--$do$
--DECLARE
--	cti covid_travellers_info;
--BEGIN
--	FOR cti IN (select
--                *
--                from
--                covid_travellers_info info
--                inner join location_master loc on info.location_id = loc.id
--                where location_id is not null
--                and location_id > 0
--                and member_id is null
--                and loc.type in ('A','AA')) LOOP
--		with get_asha_area_id as (
--           select
--           case
--               when parent_loc_type in ('A','AA') then parent_id
--               when parent_loc_type in ('V','ANG') then child_id
--           end as location_id
--           from location_hierchy_closer_det
--           where parent_id = cti.location_id
--           limit 1
--       ),
--       insert_imt_family as (
--           insert into public.imt_family (address1, area_id, caste, created_on, family_id, religion, location_id, state, basic_state, created_by, modified_by, modified_on)
--           select
--           cti.address as address, (select location_id from get_asha_area_id) as area_id, '627' as caste, now() as created_on, 'FM/' || date_part('YEAR', NOW()) || '/' || nextval('family_id_seq') || 'N' as family_id,
--           '640' as religion, (select case when type in ('A','AA') then parent else id end from location_master where id = cti.location_id) as location_id,
--           case
--               when cti.input_type = 'DR_TECHO' then 'IDSP_DR_TECHO'
--               when cti.input_type = 'MY_TECHO' then 'IDSP_MY_TECHO'
--               else 'IDSP_TECHO'
--           end as state, 'IDSP' as basic_state, '-1', '-1', now()
--           returning family_id
--       ),
--       insert_imt_member as (
--           insert into public.imt_member(unique_health_id, first_name, dob, gender, state, basic_state, created_by, created_on, modified_by, modified_on, family_head, family_id)
--           select 'A' || nextval('member_unique_health_id_seq') || 'N' as unique_health_id, cti.name, '1970-01-01' as dob,
--           case
--		        when cti.gender ilike 'm' or cti.gender ilike 'male' then 'M'
--		        when cti.gender ilike 'f' or cti.gender ilike 'female' then 'F'
--		        else 'OTHER'
--		    end as gender,
--           case
--               when cti.input_type = 'DR_TECHO' then 'IDSP_DR_TECHO'
--               when cti.input_type = 'MY_TECHO' then 'IDSP_MY_TECHO'
--               else 'IDSP_TECHO'
--           end as state, 'IDSP' as basic_state, '-1', now(), '-1', now(), true, (select family_id from insert_imt_family)
--           returning id
--       ),
--       update_covid_travellers_info as (
--           update covid_travellers_info
--           set member_id = (select id from insert_imt_member)
--           where id = cti.id
--       )
--       update
--       imt_family
--       set hof_id  = (select id from insert_imt_member)
--       where family_id = (select family_id from insert_imt_family);
--	END LOOP;
--END
--$do$;
