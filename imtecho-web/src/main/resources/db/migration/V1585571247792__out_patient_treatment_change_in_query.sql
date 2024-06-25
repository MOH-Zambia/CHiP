delete from query_master qm where qm.code='retrieve_opd_patients_for_treatment';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1,'2020-03-26 00:00:00.000',80208,'2020-03-30 17:39:24.086','retrieve_opd_patients_for_treatment','fetchPendingOnly,searchDate,userId','select
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
    -- and im.basic_state in (''NEW'', ''VERIFIED'', ''REVERIFICATION'', ''TEMPORARY'')
    and romr.health_infra_id in (select health_infrastrucutre_id from user_health_infrastructure uhi where user_id = #userId#)
    order by romr.registration_date desc',true,'ACTIVE','Retrieve OPD Patients for Treatment',true)
;