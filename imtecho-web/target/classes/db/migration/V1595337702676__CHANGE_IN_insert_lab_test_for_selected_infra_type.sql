DELETE FROM QUERY_MASTER WHERE CODE='insert_lab_test_for_selected_infra_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'6dfc82a5-0c6f-4c18-87a3-af9d19ac6459', 75398,  current_date , 75398,  current_date , 'insert_lab_test_for_selected_infra_type', 
'permissionType,infraTypeIds,refId', 
'delete
from
	health_infrastructure_lab_test_mapping
where
    health_infra_id is null and
	ref_id = #refId#
	and permission_type = #permissionType#;

 insert
	into
		health_infrastructure_lab_test_mapping( health_infra_type, ref_id, permission_type )
	values (unnest(cast(#infraTypeIds# as int[])), #refId#, #permissionType# )', 
null, 
false, 'ACTIVE');