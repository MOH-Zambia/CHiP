DELETE FROM QUERY_MASTER WHERE CODE='register_opd_patient';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'8bfe0bfa-48fa-4f16-9f13-12e94b90569a', 97070,  current_date , 97070,  current_date , 'register_opd_patient',
'healthInfrastructureId,registrationDate,referenceType,loggedInUserId,referenceId,memberId',
'with get_location_id as (
        select
        case
            when if.area_id is not null then if.area_id
            else if.location_id
        end as location_id
        from imt_family if
        inner join imt_member im on im.family_id = if.family_id
        where im.id = #memberId#
    )
    INSERT
    INTO
    rch_opd_member_registration
    (member_id, registration_date, health_infra_id, created_by, created_on, modified_by, modified_on, reference_id, reference_type, location_id)
    VALUES
    (#memberId#, #registrationDate#, #healthInfrastructureId#, #loggedInUserId#, now(), #loggedInUserId#, now(), #referenceId#, #referenceType#,
        (select location_id from get_location_id)
    ) returning id;',
'Register OPD Patient',
true, 'ACTIVE');