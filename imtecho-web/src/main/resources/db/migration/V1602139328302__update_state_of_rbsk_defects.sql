DELETE FROM QUERY_MASTER WHERE CODE='update_state_of_rbsk_defects';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f0f8fd82-0bfb-4272-a44b-bfdda6d4a5fd', 75398,  current_date , 75398,  current_date , 'update_state_of_rbsk_defects',
'state,id',
'update
	rbsk_defect_configuration
set
	state = #state#,
    modified_on = now()
where
	id = #id#;',
null,
false, 'ACTIVE');