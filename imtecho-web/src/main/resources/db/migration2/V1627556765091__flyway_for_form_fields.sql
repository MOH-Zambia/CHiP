DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_constraint_field_masters';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'0c87c87a-3611-4ade-806a-29b24b444027', 60512,  current_date , 60512,  current_date , 'retrieve_system_constraint_field_masters',
'form_uuid',
'select cast(uuid as text) as uuid,
cast(form_master_uuid as text) as form_master_uuid,
field_key,field_name,field_type,ng_model,app_name,
cast(standard_field_master_uuid as text) as standard_field_master_uuid,
created_by,modified_by
from system_constraint_field_master
where form_master_uuid = cast(#form_uuid# as uuid)',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='retrieve_system_constraint_field_value_masters';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4aa13957-5131-45af-9bbb-87fab686c0ba', 60512,  current_date , 60512,  current_date , 'retrieve_system_constraint_field_value_masters',
'form_uuid',
'select cast(system_constraint_field_value_master.uuid as text) as uuid,
cast(system_constraint_field_value_master.field_master_uuid as text) as field_master_uuid,
system_constraint_field_value_master.value_type,
system_constraint_field_value_master.key,
system_constraint_field_value_master.value,
system_constraint_field_value_master.default_value,
system_constraint_field_value_master.created_by,
system_constraint_field_value_master.modified_by
from system_constraint_field_value_master
inner join system_constraint_field_master on system_constraint_field_value_master.field_master_uuid = system_constraint_field_master.uuid
where system_constraint_field_master.form_master_uuid = cast(#form_uuid# as uuid)',
null,
true, 'ACTIVE');