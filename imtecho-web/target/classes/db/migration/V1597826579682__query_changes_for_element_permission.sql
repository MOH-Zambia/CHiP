DELETE FROM QUERY_MASTER WHERE CODE='insert_soh_element_permissions';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'5a2f6f8f-6915-4bef-a6d5-52d8e06a5336', 80314,  current_date , 80314,  current_date , 'insert_soh_element_permissions',
'elementId,permissionType,ref_ids',
'delete
from
	soh_element_permissions
where
	element_id = #elementId#
	and permission_type = ''ALL'';
insert
	into
		soh_element_permissions( element_id, permission_type, reference_id )
	values(#elementId#, ''#permissionType#'',
unnest( array#ref_ids#))',
null,
false, 'ACTIVE');

