
-- retrieve_opd_patients_for_treatment

delete from query_master where code='retrieve_opd_patients_for_treatment';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_patients_for_treatment', 'userId,searchDate,fetchPendingOnly', '
    select
    im.id as "memberId",
    im.unique_health_id as "uniqueHealthId",
    if.family_id as "familyId",
    concat(im.first_name, '' '', im.middle_name, '' '', im.last_name) as "name",
    im.dob as "dob",
    cast(age(im.dob) as text) as "age",
    if.location_id as "locationId",
    if.area_id as "areaId",
    get_location_hierarchy(if.location_id) as "locationHierarchy",
    romr.id as "opdMemberRegistrationId",
    romr.registration_date as "registrationDate",
    romr.health_infra_id as "healthInfraId",
    hid.name as "healthInfraName"
    from rch_opd_member_registration romr
    inner join imt_member im on im.id = romr.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romr.health_infra_id
    left join rch_opd_member_master romm on romr.id = romm.opd_member_registration_id
    where
        (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    -- and cast(romr.registration_date as date) = cast(''#searchDate#'' as date)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romr.registration_date
', true, 'ACTIVE', 'Retrieve OPD Patients for Treatment');

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

