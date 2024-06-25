-- queries for feature of mange schools
-- https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3036


delete from query_master where code='loaction_ward_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'loaction_ward_retrieval', 'limit,offset', '
    SELECT
    lw.id,
	lw.ward_name as "wardName",
	lw.lgd_code as "lgdCode",
	lw.location_id as "locationId",
	get_location_hierarchy(lw.location_id) as "locationHierarchy",
	cast(json_agg(lwm.location_id) as text) as "assignedUPHCIds",
	cast(json_agg(lm.name) as text) as "assignedUPHCs"
 	from public.location_wards lw
 	left join location_wards_mapping lwm on lwm.ward_id = lw.id
 	left join location_master lm on lm.id = lwm.location_id
 	group by lw.id
  	limit #limit# offset #offset#
', true, 'ACTIVE', 'Location Ward Retrieval');

--

delete from query_master where code='loaction_ward_retrieval_by_id';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'loaction_ward_retrieval_by_id', 'id', '
    SELECT
    lw.id,
	lw.ward_name as "wardName",
	lw.lgd_code as "lgdCode",
	lw.location_id as "locationId",
	get_location_hierarchy(lw.location_id) as "locationHierarchy",
	cast(json_agg(lwm.location_id) as text) as "assignedUPHCIds",
	cast(json_agg(lm.name) as text) as "assignedUPHCs"
 	from public.location_wards lw
 	left join location_wards_mapping lwm on lwm.ward_id = lw.id
 	left join location_master lm on lm.id = lwm.location_id
    where lw.id = #id#
 	group by lw.id
', true, 'ACTIVE', 'Location Ward Retrieval By Id');

--

delete from query_master where code='loaction_ward_uphc_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'loaction_ward_uphc_retrieval', 'level,locationType,parentId,wardId', '
    select
    m.id,
    m.name,
    t.type as "typeCode",
    t.name as "type",
    m.parent as "areaParentId"
    from location_hierchy_closer_det c
    inner join location_type_master t on t.type = c.child_loc_type
    inner join location_master m on m.id = c.child_id
    left join location_wards_mapping lwm on lwm.location_id = m.id
    where t.level=#level#
    and t.type=''#locationType#''
    and parent_id=#parentId#
    and (lwm.ward_id is null or (lwm.ward_id is not null and lwm.ward_id=#wardId#))
    order by depth
', true, 'ACTIVE', 'Location Ward UPHC Retrieval');

--

delete from query_master where code='location_ward_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_create','wardName,lgdCode,locationId,createdBy,createdOn,modifiedBy,modifiedOn','
INSERT INTO public.location_wards(
    ward_name, lgd_code, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#wardName#'', ''#lgdCode#'', #locationId#, #createdBy#, ''#createdOn#'', #modifiedBy#, ''#modifiedOn#''
    ) returning id;', true, 'ACTIVE', 'Create Location Ward');

--

delete from query_master where code='location_ward_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_update', 'id,wardName,lgdCode,locationId,modifiedBy,modifiedOn','
UPDATE public.location_wards
    SET
    "ward_name"=''#wardName#'', lgd_code=''#lgdCode#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=''#modifiedOn#''
    WHERE id=#id#;', false, 'ACTIVE', 'Update Location Ward');
