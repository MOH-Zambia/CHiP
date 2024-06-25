DELETE FROM QUERY_MASTER WHERE CODE='health_infra_type_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'32a4d42c-8708-4d42-9377-56bac843e403', 74841,  current_date , 74841,  current_date , 'health_infra_type_mapping', 
'offset,limit,type', 
'select hitl.health_infra_type_id, 
case when lfvd.is_active then ''ACTIVE'' else ''INACTIVE'' end as state,
lfvd.value as value, string_agg(hitl.location_type,'','') as location_type, 
string_agg('''' || hitl.location_level,'','') as location_level,
string_agg(ltm.name, '','')  as name
from health_infrastructure_type_location hitl 
left join listvalue_field_value_detail lfvd on lfvd.id = hitl.health_infra_type_id 
left join location_type_master ltm on ltm.type = hitl.location_type
where case when (#type# is null or #type# = '''') then true else ltm.name ilike (''%'' || #type# || ''%'') end
group by hitl.health_infra_type_id, lfvd.value, lfvd.is_active
order by lfvd.is_active desc, hitl.health_infra_type_id
limit #limit# offset #offset#', 
null, 
true, 'ACTIVE');


DELETE FROM QUERY_MASTER WHERE CODE='delete_health_infra_mapping';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'1229a93d-98b5-490b-90ab-5d1ea16591e4', 74841,  current_date , 74841,  current_date , 'delete_health_infra_mapping', 
'is_active,is_archive,id,userId', 
'UPDATE listvalue_field_value_detail
SET is_active= #is_active#, 
is_archive= #is_archive#, 
last_modified_by = #userId#, 
last_modified_on = now()
WHERE id= #id#;', 
null, 
false, 'ACTIVE');