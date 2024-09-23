DELETE FROM QUERY_MASTER WHERE CODE='get_all_health_facilities';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'd329c640-ce33-40a9-9927-edb6db959799', 97182,  current_date , 97182,  current_date , 'get_all_health_facilities',
'locationId',
'with location_detail as (
	select child_id
	from location_hierchy_closer_det
	where parent_id = #locationId#
)
SELECT
	hid.id as facility_id,
	hid.name as facility_name, hid.is_enabled,
	(
		select name
	 	from location_master
	 	where id = (
				select parent_id
				from location_hierchy_closer_det
				where child_id = hid.location_id and parent_loc_type = ''D''
		)
	) as district_name,
	(select name
	 from location_master
	 where id = (select parent_id
				 from location_hierchy_closer_det
				 where child_id = hid.location_id and parent_loc_type = ''P'')) as province_name


FROM health_infrastructure_details hid
INNER JOIN location_detail ld on ld.child_id = hid.location_id
where hid.dhis2_uid is not null;',
'Gets list of all facilitiess details having mapped dhis2 org unit id',
true, 'ACTIVE');