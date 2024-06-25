alter table rch_opd_member_master alter column medicines_given_on drop not null;


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_opd_patients_for_medicines';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'461e82bd-ed63-4507-ac4f-31ffd5d9100d', 1,  current_date , 1,  current_date , 'retrieve_opd_patients_for_medicines',
'userId',
'
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
    and (cast(romm.medicines_given_on as date) = current_date or romm.medicines_given_on is null)
    and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'', ''UNHANDLED'', ''IDSP'')
    and romm.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId# and state = ''ACTIVE'')
    order by romm.medicines_given_on
',
'Retrieve OPD Patients for Medicines',
true, 'ACTIVE');