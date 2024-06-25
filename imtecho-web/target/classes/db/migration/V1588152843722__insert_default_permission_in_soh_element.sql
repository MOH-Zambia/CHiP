DELETE FROM QUERY_MASTER WHERE CODE='insert_default_permission_in_soh_element';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
74909,  current_date , 74909,  current_date , 'insert_default_permission_in_soh_element',
 null,
'insert
	into
		soh_element_permissions( element_id, permission_type )
		select id, ''ALL'' from soh_element_configuration where element_name != ''COVID_STATUS_REPORT''',
null,
false, 'ACTIVE');