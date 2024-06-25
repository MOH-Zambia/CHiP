delete from query_master qm where qm.code ='dr_techo_get_dr_techo_users_by_crieteria';

INSERT INTO query_master (created_by,created_on,modified_by,modified_on,code,params,query,returns_result_set,state,description,is_public) VALUES 
(1, current_date, 1, current_date, 'dr_techo_get_dr_techo_users_by_crieteria',
'offset,limit,orderBy,mobileNo,states', '
    select uu.id,
    concat(uu.first_name, '' '', uu.middle_name, '' '', uu.last_name) as "fullName",
    uu.user_name as "userName",
    uu.gender,
    udu.registration_number as "registrationNumber",
    uu.contact_number as "contactNumber",
    uu.address as address,
    udu.medical_council as "medicalCouncil",
    uu.state,
    udu.remarks,
    udu.action_on as "actionOn",
    concat(uu2.first_name, '' '', uu2.middle_name, '' '', uu2.last_name) as "actionBy",
    (select 
        cast(
            json_agg(
                json_build_object(
                    ''id'', hid.id,
                    ''healthInfrastructureName'', hid.name,
                    ''healthInfrastructurePincode'', hid.postal_code,
                    ''healthInfrastructureRegNo'', hid.registration_number,
                    ''healthInfrastructureAddress'', hid.address
                )
            ) as text
        ) from user_health_infrastructure uhi inner join health_infrastructure_details hid on hid.id = uhi.health_infrastrucutre_id where uhi.user_id = uu.id AND uhi.state = ''ACTIVE''
    ) as "healthInfrastructureDetails",
    (select
        cast(
            json_agg(
                json_build_object(
                    ''id'', lfvd.id,
                    ''value'', lfvd.value
                )
            ) as text
        ) from listvalue_field_value_detail lfvd where lfvd.field_key=''drtecho_user_document_types'' and lfvd.is_active = true
    ) as "documentTypes",
    (select
        cast(
            json_agg(
                json_build_object(
                    ''id'', dud.document_id,
                    ''typeId'', dud.document_type_id, 
                    ''name'', dm.actual_file_name
                )
            ) as text
        ) from drtecho_user_documents dud inner join document_master dm on dm.id = dud.document_id where dud.user_id = uu.id
    ) as "documentDetails"
    from um_user uu  
    inner join um_drtecho_user udu on uu.id = udu.user_id
    left join um_user uu2 on uu2.id = udu.action_by
    where uu.state in (#states#) and uu.role_id = 203
    and uu.contact_number like ''%#mobileNo#%'' group by uu.id , udu.id , uu2.id order by #orderBy# desc
    limit #limit# offset #offset#;
', true, 'ACTIVE', NULL, true);
