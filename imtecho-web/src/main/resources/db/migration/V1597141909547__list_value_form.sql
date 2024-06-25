DELETE FROM QUERY_MASTER WHERE CODE='retrieve_field_values_for_form_field';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'931f76f0-7c59-490d-ace0-023ba4414912', 74841,  current_date , 74841,  current_date , 'retrieve_field_values_for_form_field', 
'form,fieldKey', 
'select value as value , v.id as id from listvalue_field_master f , listvalue_field_value_detail  v
where f.field_key=v.field_key and f.form = #form# and v.field_key=#fieldKey#
and v.is_active=true', 
'Retrieve field values for particular field key and form ', 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='retrieve_field_values_for_form_with_health_infra_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'a461ddaa-07be-4237-b938-df8db4a2b932', 74841,  current_date , 74841,  current_date , 'retrieve_field_values_for_form_with_health_infra_type', 
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
where f.field_key=v.field_key and f.form = #form# and v.field_key= #fieldKey# and tm.health_infra_type_id = v.id
and v.is_active=true', 
null, 
true, 'ACTIVE');