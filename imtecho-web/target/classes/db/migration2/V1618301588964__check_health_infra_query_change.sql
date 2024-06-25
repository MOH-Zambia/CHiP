-- 5042

DELETE FROM QUERY_MASTER WHERE CODE='check_health_infra_assignable_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'99b2a541-cebe-4872-9980-ee3bd19cdde8', 60512,  current_date , 60512,  current_date , 'check_health_infra_assignable_location',
'locationId,healthInfraType',
'with type_mapping as (
	select health_infra_type_id, string_agg(ltm.name, '','') as loc_value, string_agg(ltm."type", '','') as loc_types from health_infrastructure_type_location hitl
	left join location_type_master ltm on ltm.type = hitl.location_type
	where hitl.health_infra_type_id = #healthInfraType#
	group by health_infra_type_id
)

select lm.type,ltm.level, type_mapping.*  from location_master lm
left join location_type_master ltm on ltm."type" = lm.type
left join type_mapping on true
where lm.id = #locationId#',
null,
true, 'ACTIVE');