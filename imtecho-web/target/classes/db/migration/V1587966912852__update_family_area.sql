
INSERT INTO public.menu_config
( feature_json, group_id, active, is_dynamic_report, menu_name, navigation_state, sub_group_id, menu_type, only_admin, menu_display_order)
VALUES( '{}', (select id from menu_group where group_name = 'Administration' and group_type = 'manage'), true, NULL, 'Update Family Area', 'techo.manage.updateFamilyAreaList', NULL, 'manage', NULL, NULL);


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_families_to_update_area';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
-1, current_date , -1,  current_date , 'retrieve_families_to_update_area',
'locationId,limit,offset',
'
    with pending_count as (
        select
            count(*) as "count"
        from
            imt_family if
        where
            if.location_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
            and if.area_id is null
    )
    select
        if.*,
        get_location_hierarchy(if.location_id) as "locationHierarchy",
        concat(im1.first_name, '' '', im1.middle_name, '' '', im1.last_name) as "contactPersonName",
        im1.unique_health_id as "contactPersonUniqueHealthId",
        concat(im2.first_name, '' '', im2.middle_name, '' '', im2.last_name) as "hofName",
        im2.unique_health_id as "hofUniqueHealthId",
        (select count from pending_count) as "pendingCount",
        get_location_hierarchy(#locationId#) as "currentLocationHierarchy"
    from
        imt_family if
    left join
        imt_member im1 on im1.id = if.contact_person_id
    left join
        imt_member im2 on im2.id = if.hof_id
    where
        if.location_id in (select lhcd.child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#)
        and if.area_id is null
    limit #limit# offset #offset#;
',
'Retrieve families to update the area',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='update_family_area';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
-1, current_date , -1,  current_date , 'update_family_area',
'id,areaId,loggedInUserId',
'
    update
        imt_family
    set
        area_id = #areaId#,
        modified_by = #loggedInUserId#,
        modified_on = now()
    where
        id = #id#;
',
'Update family area',
false, 'ACTIVE');