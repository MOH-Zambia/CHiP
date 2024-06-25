
delete from query_master where code='loaction_ward_retrieval';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values
(1, current_date, 'loaction_ward_retrieval', 'limit,offset,locationId', '
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
 	WHERE lw.location_id in (select child_id from location_hierchy_closer_det lhcd where lhcd.parent_id = #locationId#) or ''#locationId#'' = ''null'' or ''#locationId#'' = ''''
 	group by lw.id
  	limit #limit# offset #offset#
', true, 'ACTIVE', 'Location Ward Retrieval');

--