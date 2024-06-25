DELETE FROM QUERY_MASTER WHERE CODE='register_opd_patient';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'8bfe0bfa-48fa-4f16-9f13-12e94b90569a', 75398,  current_date , 75398,  current_date , 'register_opd_patient', 
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
    );', 
'Register OPD Patient', 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_iucd_removal';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a8c1c9fd-acce-4032-a3e7-f7545f05f6e5', 75398,  current_date , 75398,  current_date , 'update_iucd_removal', 
'iucdRemovalReason,iucdRemovalDate,loggedInUserId,memberId', 
'update imt_member
set is_iucd_removed = true,
last_method_of_contraception = null,
fp_insert_operate_date = null,
iucd_removal_date = #iucdRemovalDate#,
iucd_removal_reason = #iucdRemovalReason#,
modified_on = now(),
modified_by = #loggedInUserId#
where id = #memberId#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_fp_method';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2b31c2c-e347-4644-9382-ceeb6b462ba3', 75398,  current_date , 75398,  current_date , 'update_fp_method', 
'healthInfrastructure,familyPlanningMethod,fpInsertOperateDate,loggedInUserId,memberId', 
'update imt_member
set last_method_of_contraception = #familyPlanningMethod#,
fp_insert_operate_date = #fpInsertOperateDate#,
family_planning_health_infra = #healthInfrastructure#,
is_iucd_removed = null,
modified_on = now(),
modified_by = #loggedInUserId#
where id = #memberId#', 
null, 
false, 'ACTIVE');