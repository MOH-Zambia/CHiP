DELETE FROM QUERY_MASTER WHERE CODE='health_infra_type_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'32a4d42c-8708-4d42-9377-56bac843e403', 74841,  current_date , 74841,  current_date , 'health_infra_type_mapping', 
'offset,limit,type', 
'select hitl.health_infra_type_id, 
lfvd.value as value, string_agg(hitl.location_type,'','') as location_type, 
string_agg('''' || hitl.location_level,'','') as location_level,
string_agg(ltm.name, '','')  as name
from health_infrastructure_type_location hitl 
left join listvalue_field_value_detail lfvd on lfvd.id = hitl.health_infra_type_id 
left join location_type_master ltm on ltm.type = hitl.location_type
where case when (#type# is null or #type# = '''') then true else ltm.name ilike (''%'' || #type# || ''%'') end
group by hitl.health_infra_type_id, lfvd.value
order by hitl.health_infra_type_id
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='delete_health_infra_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1229a93d-98b5-490b-90ab-5d1ea16591e4', 74841,  current_date , 74841,  current_date , 'delete_health_infra_mapping', 
'id', 
'delete from health_infrastructure_type_location
where id = #id#', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='check_health_infra_assignable_location';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'99b2a541-cebe-4872-9980-ee3bd19cdde8', 74841,  current_date , 74841,  current_date , 'check_health_infra_assignable_location', 
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
where id = #locationId#', 
null, 
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='insert_health_infra_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'2e24c30e-d846-4fd2-af52-6513c89217cc', 74841,  current_date , 74841,  current_date , 'insert_health_infra_type', 
'code,userId,value,location_type', 
'with insert_listvalue as (
INSERT INTO listvalue_field_value_detail
(is_active, is_archive, last_modified_by, last_modified_on, value, field_key, file_size, multimedia_type, code)
VALUES(true, false, #userId#, now(), #value#, ''infra_type'', 0, NULL, #code#)
returning id),
json_config as (
	select json_array_elements(cast(#location_type# as json)) as data
)
INSERT INTO health_infrastructure_type_location
(health_infra_type_id, location_type, location_level)
select (select id from insert_listvalue), data ->> ''type'' as location_type, 
cast(data ->> ''level'' as integer) as location_level from json_config', 
null, 
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='update_health_infra_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'daca9891-8bb2-4114-a5cd-0a18a5ab0538', 74841,  current_date , 74841,  current_date , 'update_health_infra_mapping', 
'id,userId,value,location_type', 
'with insert_listvalue as (
	 UPDATE listvalue_field_value_detail
	SET last_modified_by= #userId#, 
	last_modified_on= now(), 
	value= #value#, 
	field_key=''infra_type''
	WHERE id=#id#
	returning id
),json_config as (
	select json_array_elements(cast(#location_type# as json)) as data
), remove_mapping as (
	delete from health_infrastructure_type_location
	where health_infra_type_id = #id#
	returning id
)
INSERT INTO health_infrastructure_type_location
(health_infra_type_id, location_type, location_level)
select (select id from insert_listvalue), data ->> ''type'' as location_type, 
cast(data ->> ''level'' as integer) as location_level from json_config', 
null, 
false, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_locations_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'86a64620-97fc-480a-98c3-f724824ae5de', 74841,  current_date , 74841,  current_date , 'get_locations_type', 
 null, 
'select type,name,level from location_type_master', 
null, 
true, 'ACTIVE');

update menu_config
set feature_json = cast(feature_json as jsonb) || jsonb '{"canManageHealthInfraType":true}'
where menu_name = 'Health Facility Mapping';

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_field_values_for_form_field';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'931f76f0-7c59-490d-ace0-023ba4414912', 74841,  current_date , 74841,  current_date , 'retrieve_field_values_for_form_field', 
'form,fieldKey', 
'with type_mapping as (
	select health_infra_type_id, string_agg(ltm.name, '','') as loc_value, string_agg(ltm."type", '','') as loc_types ,
string_agg('''' || hitl.location_level, '','') as location_level
from health_infrastructure_type_location hitl
	left join location_type_master ltm on ltm.type = hitl.location_type
	group by health_infra_type_id
)

select value as value , v.id as id, tm.loc_value, tm.loc_types, tm.location_level
from listvalue_field_master f , listvalue_field_value_detail  v, type_mapping tm 
where f.field_key=v.field_key and f.form = #form# and v.field_key=#fieldKey# and tm.health_infra_type_id = v.id
and v.is_active=true', 
'Retrieve field values for particular field key and form ', 
true, 'ACTIVE');