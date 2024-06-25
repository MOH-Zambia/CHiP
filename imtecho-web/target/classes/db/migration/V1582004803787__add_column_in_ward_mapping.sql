-- for issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/3176

alter table location_wards
drop COLUMN IF EXISTS ward_name_english,
add COLUMN ward_name_english varchar(255);

--

delete from query_master where code='loaction_ward_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'loaction_ward_retrieval', 'limit,offset', '
    SELECT
    lw.id,
	lw.ward_name as "wardName",
	lw.ward_name_english as "wardNameEnglish",
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
	lw.ward_name_english as "wardNameEnglish",
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

delete from query_master where code='location_ward_create';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_create','wardName,wardNameEnglish,lgdCode,locationId,createdBy,modifiedBy','
INSERT INTO public.location_wards(
    ward_name, ward_name_english, lgd_code, location_id, created_by, created_on, modified_by, modified_on)
    VALUES (
        ''#wardName#'', ''#wardNameEnglish#'', ''#lgdCode#'', #locationId#, #createdBy#, now(), #modifiedBy#, now()
    ) returning id;', true, 'ACTIVE', 'Create Location Ward');

--

delete from query_master where code='location_ward_update';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, now(),
'location_ward_update', 'id,wardName,wardNameEnglish,lgdCode,locationId,modifiedBy','
UPDATE public.location_wards
    SET
    "ward_name"=''#wardName#'', ward_name_english=''#wardNameEnglish#'', lgd_code=''#lgdCode#'', location_id=#locationId#, modified_by=#modifiedBy#, modified_on=now()
    WHERE id=#id#;', false, 'ACTIVE', 'Update Location Ward');

--