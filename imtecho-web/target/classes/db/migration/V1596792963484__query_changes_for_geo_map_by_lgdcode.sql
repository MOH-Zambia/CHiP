DELETE FROM QUERY_MASTER WHERE CODE='get_geo_map_by_lgdcode';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6d402403-b75e-4cb6-88bc-479a3289efec', 74909,  current_date , 74909,  current_date , 'get_geo_map_by_lgdcode',
'lgdCode',
'with lgc_codes as (
	 select lgd_code from location_master where id  in (select parent_id from location_hierchy_closer_det lh  where lh.parent_loc_type  in (''V'',''C'') and child_id in(#lgdCode#))
union all
	select lgd_code from location_master where id  in (select parent_id from location_hierchy_closer_det lh  where lh.parent_loc_type  in (''B'') and child_loc_type =''AA'' and child_id in(#lgdCode#))
)
select ST_AsGeoJSON(geom),lgd_code from location_geo_coordinates where lgd_code in (select lgd_code from lgc_codes);',
null,
true, 'ACTIVE');