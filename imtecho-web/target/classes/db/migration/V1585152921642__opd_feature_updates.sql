
-- for feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3441


alter table rch_opd_member_master
drop column if exists opd_member_registration_id,
add column opd_member_registration_id integer;

alter table rch_opd_member_master
drop column if exists is_medicines_given,
add column is_medicines_given boolean;

alter table rch_opd_member_registration
drop column if exists reference_id,
add column reference_id integer;

alter table rch_opd_member_registration
drop column if exists reference_type,
add column reference_type varchar(50);

-- retrieve_opd_registered_patients

delete from query_master where code='retrieve_opd_registered_patients';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_registered_patients', 'userId,searchDate,fetchPendingOnly', '
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
    where cast(romr.registration_date as date) = cast(''#searchDate#'' as date)
    and (case
            when #fetchPendingOnly# = true then romm.id is null
            else true
        end)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romr.registration_date
', true, 'ACTIVE', 'Retrieve OPD Registered Patients');


-- retrieve_opd_patients_for_medicines

delete from query_master where code='retrieve_opd_patients_for_medicines';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'retrieve_opd_patients_for_medicines', 'userId', '
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
    romm.id as "opdMemberMasterId",
    romm.health_infra_id as "healthInfraId",
    romm.service_date as "serviceDate",
    romm.medicines_given_on as "medicinesGivenOn",
    hid.name as "healthInfraName"
    from rch_opd_member_master romm
    inner join imt_member im on im.id = romm.member_id
    inner join imt_family if on im.family_id = if.family_id
    left join health_infrastructure_details hid on hid.id = romm.health_infra_id
    where romm.is_medicines_given is not true
    and cast(romm.medicines_given_on as date) = current_date
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romm.medicines_given_on
', true, 'ACTIVE', 'Retrieve OPD Patients for Medicines');

-- register_opd_patient

delete from query_master where code='register_opd_patient';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'register_opd_patient', 'memberId,registrationDate,healthInfrastructureId,loggedInUserId,referenceId,referenceType', '
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, health_infra_id, created_by, created_on, modified_by, modified_on, reference_id, reference_type)
    VALUES
    (#memberId#, ''#registrationDate#'', #healthInfrastructureId#, #loggedInUserId#, now(), #loggedInUserId#, now(), #referenceId#, ''#referenceType#'');
', false, 'ACTIVE', 'Register OPD Patient');

-- opd_search_idsp_referred_patients_by_location_id

delete from query_master where code='opd_search_idsp_referred_patients_by_location_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'opd_search_idsp_referred_patients_by_location_id', 'offSet,locationId,limit', '
    select
    imsd.id as "idspMemberScreeningId",
    imt_member.id as "memberId",
    imt_member.unique_health_id as "uniqueHealthId",
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
    left join um_user_location uul1 on uul1.loc_id = imt_family.area_id
    and uul1.state = ''ACTIVE'' and (select uu.role_id from um_user uu where uu.id = uul1.user_id and state = ''ACTIVE'') = 24
    left join um_user uu1 on uu1.id = uul1.user_id
    left join um_user_location uul2 on uul2.loc_id = imt_family.location_id and uul2.state = ''ACTIVE''
    and (select uu.role_id from um_user uu where uu.id = uul2.user_id and state = ''ACTIVE'') = 30
    left join um_user uu2 on uu2.id = uul2.user_id
    where imsd.location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#)
    and (imsd.travel_detail is not null and imsd.travel_detail not in (''NO_TRAVEL''))
    and (imsd.is_cough or imsd.is_fever or imsd.covid_symptoms ilike ''%breathlessness%'')
    and imt_member.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    limit #limit# offset #offSet#;
', true, 'ACTIVE', 'OPD Search IDSP Referred Patients By Location ID');

