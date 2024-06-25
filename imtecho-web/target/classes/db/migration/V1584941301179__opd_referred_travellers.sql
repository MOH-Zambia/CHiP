
-- opd_search_referred_travellers_covid_19_by_location_id

delete from query_master where code='opd_search_referred_travellers_covid_19_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_referred_travellers_covid_19_by_location_id', 'offSet,locationId,limit', '
   select
   imt_member.unique_health_id as "uniqueHealthId",
   imt_member.id as "memberId",
   imt_member.family_id as "familyId",
   imt_member.mobile_number as "mobileNumber",
   imt_family.location_id as "locationId",
   get_location_hierarchy(imt_family.location_id) as "locationHierarchy",
   concat(imt_member.first_name, '' '', imt_member.middle_name, '' '', imt_member.last_name) as "name",
   imt_member.dob as "dob",
   cast(age(imt_member.dob) as text) as "age",
   concat(uu1.first_name, '' '', uu1.middle_name, '' '', uu1.last_name) as "ashaName",
   uu1.contact_number as "ashaContactNumber",
   uu1.techo_phone_number as "ashaTechoContactNumber",
   concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "anmName",
   uu2.contact_number as "anmContactNumber",
   uu2.techo_phone_number as "anmTechoContactNumber"
   from idsp_member_screening_details imsd
   inner join imt_member on imt_member.id = imsd.member_id
   inner join imt_family on imt_member.family_id = imt_family.family_id
   left join um_user_location uul1 on uul1.loc_id = imt_family.area_id and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
   left join um_user uu1 on uu1.id = uul1.user_id
   left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
   left join um_user uu2 on uu2.id = uul2.user_id
   where imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
   and imsd.is_fever is true and imsd.is_cough is true
   and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
   limit #limit# offset #offSet#;
', true, 'ACTIVE', 'OPD Search IDSP Referred Patients By Location ID');


-- area_level_location_search_for_web

delete from query_master where code='area_level_location_search_for_web';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'area_level_location_search_for_web', 'locationString', '
    select loc.id,string_agg(l.name,''>'' order by lhcd.depth desc) as "hierarchy"
    from location_master loc
    inner join location_hierchy_closer_det lhcd on lhcd.child_id = loc.id
    inner join location_master l on l.id = lhcd.parent_id
    where (loc.name ilike ''%#locationString#%'' or loc.english_name ilike ''%#locationString#%'') and loc.type in (''A'',''AA'')
    group by loc.id, loc.name
    limit 50;
', true, 'ACTIVE', 'Area Level Location Search for selectize');

-- add column in covid_travellers_info

alter table covid_travellers_info
drop column if exists is_out_of_state,
add column is_out_of_state boolean;

-- update_location_of_covid_19_traveller

delete from query_master where code='update_location_of_covid_19_traveller';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'update_location_of_covid_19_traveller', 'id,locationId,address,isOutOfState', '

    -- update location

    update covid_travellers_info
    set location_id = #locationId#,
    address = ''#address#'',
    is_out_of_state = #isOutOfState#,
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
    CROSS JOIN generate_series(1,14) as x where ct.id = #id# and location_id != -2;

', false, 'ACTIVE', 'Update Location of COVID 19 Traveller');