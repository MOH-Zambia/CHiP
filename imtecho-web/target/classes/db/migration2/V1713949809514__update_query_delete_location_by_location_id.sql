DELETE FROM QUERY_MASTER WHERE CODE='delete_location_by_location_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'28cc8665-8146-479e-bbb0-e4a36a99dc43', 97074,  current_date , 97074,  current_date , 'delete_location_by_location_id', 
'location_id', 
'begin;

delete from um_user_location
where loc_id = #location_id#;

update location_master
set parent = null,
location_hierarchy_id = null
where id = #location_id#
and state = ''ACTIVE'';

delete from location_level_hierarchy_master
where location_id = #location_id#;

delete from location_hierchy_closer_det
where child_id = #location_id#;

delete from location_hierchy_closer_det
where parent_id = #location_id#;

delete from location_master
where id = #location_id#;

commit;', 
'N/A', 
false, 'ACTIVE');