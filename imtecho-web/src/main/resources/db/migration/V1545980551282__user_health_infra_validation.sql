/**
Retrieves all the health infrastructure for the given location and its child locations 
and role id
**/
delete from query_master where code='retrieve_infra_by_role_location';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_infra_by_role_location','locationIds,roleId','
select r.id as roleId ,r.name as rolename,h.type as type, h.name as infrastructureName,h.id as infraId, h.location_id as locationId 
from health_infrastructure_details h ,um_role_master r  ,
 role_health_infrastructure_type  rh
 where h.type = rh.health_infrastructure__type_id and r.id= rh.role_id
 and ( location_id IN (select d.child_id from location_master  m,
 location_hierchy_closer_det d where m.id=d.child_id and (''#locationIds#''= ''null'' or parent_id in (#locationIds#))
 order by depth asc
 )  ) and rh.state=''ACTIVE'' and role_id=#roleId#
',true,'ACTIVE','Retrieves all the health infrastructure for the given location and its child locations 
and role id');