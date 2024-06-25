-- Manage FAQ

DELETE FROM QUERY_MASTER WHERE CODE='mytecho_update_faq_status';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'73e7ca41-7573-4bb5-a926-7c7f31bc17ad', 69973,  current_date , 69973,  current_date , 'mytecho_update_faq_status', 
'loggedInUserId,id,status', 
'UPDATE mytecho_faq_master SET is_active=#status#,modified_by = #loggedInUserId#,modified_on = NOW() WHERE id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_add_faq_category';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'3a2ce272-6287-44de-9888-ba3e7094ee69', 69973,  current_date , 69973,  current_date , 'mytecho_add_faq_category', 
'loggedInUserId,value', 
'insert into listvalue_field_value_detail(
	is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size)
select true, false, #loggedInUserId# ,now(), #value#, ''my_techo_faq_category_type'', 0
where not exists (select id from listvalue_field_value_detail where value = #value#)', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_update_category_value';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f2a7b5e9-96f5-4d17-9f25-70187cd4a50e', 69973,  current_date , 69973,  current_date , 'mytecho_update_category_value', 
'id,value', 
'update listvalue_field_value_detail set last_modified_on = now(), value = #value# where id = #id#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='mytecho_get_faq_categorywise';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'66764598-bffa-4908-9b34-30423aaf9ef4', 69973,  current_date , 69973,  current_date , 'mytecho_get_faq_categorywise', 
'id', 
'select id from mytecho_faq_details where category_id = #id#', 
null, 
true, 'ACTIVE');


-- RBSK Defects Configuration

DELETE FROM QUERY_MASTER WHERE CODE='update_state_of_rbsk_defects';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'f0f8fd82-0bfb-4272-a44b-bfdda6d4a5fd', 75398,  current_date , 75398,  current_date , 'update_state_of_rbsk_defects', 
'state,id', 
'update
	rbsk_defect_configuration
set
	state = #state#
where
	id = #id#;', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_stabilization_info_status';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'399b37b2-2132-447b-a60f-b8902fd5e324', 75398,  current_date , 75398,  current_date , 'update_stabilization_info_status', 
'code,status', 
'update
	rbsk_defect_stabilization_info
set
	status = #status#
where
	code = #code#', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_rbsk_stabilization_info';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6ba3e709-b350-45f4-86f7-90521dcb6824', 75398,  current_date , 75398,  current_date , 'insert_rbsk_stabilization_info', 
'code,description', 
'insert
	into
		rbsk_defect_stabilization_info( code, description, status )
	values( #code#, #description#, ''ACTIVE'' );', 
null, 
false, 'ACTIVE');


--SOH- Element Configuration

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_configuration_by_key';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'91c31904-5a17-4eab-bcea-1be08c18929e', 75398,  current_date , 75398,  current_date , 'retrieve_system_configuration_by_key', 
'key', 
'SELECT
    system_key as "key",
    is_active as "isActive",
    key_value as "value"
    FROM public.system_configuration
    WHERE system_key = #key#;', 
'Retrieve System Configuration Details By Key', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_system_configuration_by_key';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'bd4c270b-ce01-4961-81bf-76f4eff50a12', 75398,  current_date , 75398,  current_date , 'update_system_configuration_by_key', 
'isActive,value,key', 
'UPDATE public.system_configuration
    SET
    is_active = #isActive#,
    key_value = #value#
    WHERE system_key = #key#;', 
'Update System Configuration Details By Key', 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_all_soh_element_permissions';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'76782704-2d81-45b8-adad-5d256ef75501', 75398,  current_date , 75398,  current_date , 'insert_all_soh_element_permissions', 
'elementId,permissionType', 
'delete
from
	soh_element_permissions
where
	element_id = #elementId#
	and reference_id is not null;
insert
	into
		soh_element_permissions( element_id, permission_type)
	values(#elementId#, #permissionType#)', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='soh_element_analysis';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a90eea3b-84f6-4156-8efe-94c30f26277b', 75398,  current_date , 75398,  current_date , 'soh_element_analysis', 
'timelineType,lowerBoundForRural,targetMid,upperBound,upperBoundForRural,targetMidEnable,lowerBound,targetForRural,targetForUrban,target,elementName', 
'with configurations as
    (
        select
        id,
        element_name,
        element_display_short_name,
        element_display_name,
        case
            when #upperBound# = null then upper_bound
            else #upperBound#
        end as upper_bound,
        case
            when #lowerBound# = null then lower_bound
            else #lowerBound#
        end as lower_bound,
        case
            when #upperBoundForRural# = null then upper_bound_for_rural
            else #upperBoundForRural#
        end as upper_bound_for_rural,
        case
            when #lowerBoundForRural# = null then lower_bound_for_rural
            else #lowerBoundForRural#
        end as lower_bound_for_rural,
        is_small_value_positive,
        field_name,
        module,
        case
            when #target# = null then target
            else #target#
        end as target,
        case
            when #targetForRural# = null then target_for_rural
            else #targetForRural#
        end as target_for_rural,
        case
            when #targetForUrban# = null then target_for_urban
            else #targetForUrban#
        end as target_for_urban,
        case
            when #targetMid# = null then target_mid
            else #targetMid#
        end as target_mid,
        created_by,
        created_on,
        modified_on,
        modified_by,
        is_public,
        element_display_name_postfix,
        case
            when #targetMidEnable# = null then target_mid_enable
            else #targetMidEnable#
        end as target_mid_enable,
        tabs_json,
        element_order
        from soh_element_configuration
        where element_name=#elementName#
    ),
    percentages as (
        select
        location_id,
        analytics.timeline_type,
        config.*,

        -- for calculate the value
        case
            when (analytics.element_name =''IMR'' and analytics.chart1 != 0) THEN (analytics.value * 1000 / analytics.chart1)
            when (analytics.element_name =''MMR'' and analytics.chart1 != 0) THEN (analytics.value * 100000 / analytics.chart1)
            when (analytics.element_name =''ID'' and analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''SR'' and analytics.male != 0) THEN (analytics.female * 1000 / analytics.male)
            when (analytics.element_name =''SAM'' and analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''LBW'' and analytics.value != 0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value)
            when (analytics.element_name =''PREG_REG'' and analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''FI'' and analytics.chart1 != 0) THEN ((analytics.value) * 100 / analytics.chart1)
            when (analytics.element_name =''Anemia'' and (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) != 0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4))
            when (analytics.element_name =''VERIFICATION_SERVICE'' and analytics.value != 0) THEN ((analytics.chart1 * 100) / analytics.value)
            when (analytics.element_name =''PREG_VERIFICATION_SERVICE'' and analytics.value!=0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''AVG_SERVICE_DURATION'' and  analytics.value != 0) THEN ((analytics.chart1) / analytics.value)
            when (analytics.element_name =''NCD_HYPERTENSION'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_HYPERTENSION_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES_CONFIRM'' and analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100)/ config.target
            else 0
        end as calculatedTarget,

        -- for percentage calculation
        case
            when (analytics.element_name =''IMR'' and  analytics.chart1 != 0) THEN ((analytics.value * 1000 / analytics.chart1) * 100) / config.target
            when (analytics.element_name =''MMR'' and  analytics.chart1 != 0) THEN ((analytics.value * 100000 / analytics.chart1) * 100) / config.target
            when (analytics.element_name =''ID'' and  analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''SR'' and  analytics.male != 0) THEN (analytics.female * 1000 / analytics.male)
            when (analytics.element_name =''SAM'' and  analytics.chart1 != 0) THEN (analytics.value * 100 / analytics.chart1)
            when (analytics.element_name =''LBW'' and  analytics.value != 0) THEN ((analytics.chart1 + chart2) * 100 / analytics.value)
            when (analytics.element_name =''PREG_REG'' and  analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''FI'' and  analytics.chart1 != 0) THEN ((analytics.value) * 100 / analytics.chart1)
            when (analytics.element_name =''Anemia'' and  (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4) != 0) THEN ((analytics.chart1) * 100 / (analytics.chart1 + analytics.chart2 + analytics.chart3 + analytics.chart4))
            when (analytics.element_name =''VERIFICATION_SERVICE'' and  analytics.value != 0) THEN ((analytics.chart1 * 100) / analytics.value)
            when (analytics.element_name =''PREG_VERIFICATION_SERVICE'' and  analytics.value != 0) THEN ((analytics.chart1) * 100 / analytics.value)
            when (analytics.element_name =''AVG_SERVICE_DURATION'' and  analytics.value != 0) THEN ((analytics.chart1) / analytics.value)
            when (analytics.element_name =''NCD_HYPERTENSION'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES'' and  analytics.chart1 != 0) THEN (((((30 * value) / days) * 100) / chart1) * 100) / config.target
            when (analytics.element_name =''NCD_HYPERTENSION_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
            when (analytics.element_name =''NCD_DIABETES_CONFIRM'' and  analytics.chart4 != 0) THEN ((analytics.chart3 * 100 / analytics.chart4) * 100) / config.target
        end as percentage,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (target_for_rural is null or target_for_rural = 0) then config.target
                    else target_for_rural
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (target_for_urban is null or target_for_urban = 0) then config.target
                    else target_for_urban
                end
            when location.type in (''S'') then config.target
            else config.target
        end as target_1,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (lower_bound is null or lower_bound = 0) then config.lower_bound
                    else lower_bound
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (lower_bound_for_rural is null or lower_bound_for_rural = 0) then lower_bound
                    else config.lower_bound_for_rural
                end
            when location.type in (''S'') then config.lower_bound
            else config.lower_bound
        end as lower_bound_1,

        case
            when location.type in (''C'',''Z'',''U'',''ANM'',''ANG'',''AA'') then
                case
                    when (upper_bound is null or upper_bound = 0) then config.upper_bound
                    else upper_bound
                end
            when location.type in (''D'',''B'',''P'',''SC'',''V'',''A'') then
                case
                    when (upper_bound_for_rural is null or upper_bound_for_rural = 0) then upper_bound
                    else config.upper_bound_for_rural
                end
            when location.type in (''S'') then config.upper_bound
            else config.upper_bound
        end as upper_bound_1

        from soh_timeline_analytics analytics
        inner join location_master location on location.id = analytics.location_id
        inner join configurations config on analytics.element_name = config.element_name
        where analytics.location_id in (select child_id from location_hierchy_closer_det where parent_id = 2 and child_loc_type in (''D'',''C''))
        and analytics.timeline_type = #timelineType#
    ),

    calculations as(
        select
        calculatedTarget as "calculatedTarget",
        case
            when calculatedTarget < lower_bound_1 then ''UNDER_REPORTING''
            when calculatedTarget > upper_bound_1  then ''OVER_REPORTING''
            when calculatedTarget >= lower_bound_1 AND calculatedTarget <= upper_bound_1 then ''AS_EXPECTED_REPORTING''
        end as "reporting",
        case
            when is_small_value_positive then
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then ''YELLOW''
                    when percentages.target_1 > calculatedTarget  then ''GREEN''
                    else ''RED''
                end
            else
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then ''YELLOW''
                    when percentages.target_1 <= calculatedTarget then ''GREEN''
                    else ''RED''
                end
        end as "color",
        case
            when is_small_value_positive then
                case
                    when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then 2
                    when percentages.target_1 > calculatedTarget then 1
                    else 3
                end
            else
            case
                when percentages.target_1 >= calculatedTarget and target_mid <= calculatedTarget and target_mid_enable then 2
                when percentages.target_1 <= calculatedTarget then 1
                else 3
            end
        end as "sortPriority",
        element_name as "elementName",
        percentage as "percentage",
        location_id as "locationId",
        percentages.timeline_type as "timelineType"
        from percentages
        order by "sortPriority"
    )
    select
    cal.*,
    lm.name as "locationName"
    from calculations cal
    inner join location_master lm on cal."locationId" = lm.id', 
'SoH Element Analysis', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='insert_soh_element_permissions';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'5a2f6f8f-6915-4bef-a6d5-52d8e06a5336', 75398,  current_date , 75398,  current_date , 'insert_soh_element_permissions', 
'elementId,permissionType,ref_ids', 
'delete
from
	soh_element_permissions
where
	element_id = #elementId#
	and permission_type = ''ALL'';
insert
	into
		soh_element_permissions( element_id, permission_type, reference_id )
	values(#elementId#, #permissionType#,
unnest( array#ref_ids#))', 
null, 
false, 'ACTIVE');


-- Dr Techo

DELETE FROM QUERY_MASTER WHERE CODE='dr_techo_get_dr_techo_users_by_crieteria';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'479685cd-cedf-466e-a634-89cc90be571d', 75398,  current_date , 75398,  current_date , 'dr_techo_get_dr_techo_users_by_crieteria', 
'offset,limit,orderBy,mobileNo,states', 
'select uu.id,
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
    and uu.contact_number like CONCAT(''%'',#mobileNo#,''%'') group by uu.id , udu.id , uu2.id order by #orderBy# desc
    limit #limit# offset #offset#;', 
null, 
true, 'ACTIVE');