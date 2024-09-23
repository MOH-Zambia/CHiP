DELETE FROM QUERY_MASTER WHERE CODE='retrieve_all_listvalue_active_fields';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'550dfe22-819d-4ab8-a8b1-3f00c6550f66', 97074,  current_date , 97074,  current_date , 'retrieve_all_listvalue_active_fields',
 null,
'select * from listvalue_field_master where is_active = true;',
'Retrieves all listvalue fields which are ACTIVE',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_list_values_by_field_key_active';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4c2c51de-891f-4cf0-b4a4-e93f82124a59', 97074,  current_date , 97074,  current_date , 'retrieve_list_values_by_field_key_active',
'fieldKey',
'select * from listvalue_field_value_detail where field_key=#fieldKey# and is_active = true;',
'N/A',
true, 'ACTIVE');




DELETE FROM QUERY_MASTER WHERE CODE='reset_draft_medplat_form_version_history_from_stable';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f8d5920d-b70e-4c05-85fb-081e39d4d19c', 97074,  current_date , 97074,  current_date , 'reset_draft_medplat_form_version_history_from_stable',
'loggedInUserId,version,uuid',
'with medplat_form_version as (
	select * from medplat_form_version_history mfvh where version = #version# and form_master_uuid = cast( #uuid# as uuid)
)
update medplat_form_version_history
set template_config = medplat_form_version.template_config,
field_config = medplat_form_version.field_config,
form_object = medplat_form_version.form_object,
template_css = medplat_form_version.template_css,
form_vm = medplat_form_version.form_vm,
execution_sequence = medplat_form_version.execution_sequence,
query_config = medplat_form_version.query_config,
modified_by = #loggedInUserId# ,
modified_on = now()
from medplat_form_version
where medplat_form_version_history.form_master_uuid = medplat_form_version.form_master_uuid
and medplat_form_version_history.version = ''DRAFT'';',
'Updates the DRAFT version of medplat_form_version_history from the selected stable version',
false, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='retrieve_menu_config_for_form_config';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'4b491708-a8a0-4364-97af-b6c0ee83f156', 97074,  current_date , 97074,  current_date , 'retrieve_menu_config_for_form_config',
 null,
'select id, navigation_state from menu_config where menu_config.active and menu_config.menu_type <> ''report'' and menu_config.navigation_state not ilike ''techo.report%'' order by menu_config.navigation_state;',
'retrieve_menu_config_for_form_config',
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='get_form_submitted_events_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'e100b775-98cf-47b0-a8d2-97570cfa97c3', 97067,  current_date , 97067,  current_date , 'get_form_submitted_events_list',
 null,
'select cast(event_conf.uuid as text) as uuid,
event_conf.name,
event_conf.event_type as "eventType",
event_conf.form_type_id as "formTypeId", event_conf.event_type_detail_code as "eventTypeDetailCode"
from event_configuration event_conf
where event_conf.state = ''ACTIVE'' and event_conf.event_type=''FORM_SUBMITTED'';',
'retrieves all events which are of type FORM_SUBMITTED',
true, 'ACTIVE');