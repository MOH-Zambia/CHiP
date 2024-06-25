ALTER TABLE public.rch_wpd_mother_master
drop column if exists health_infrastructure_id,
ADD COLUMN health_infrastructure_id bigint;


delete from query_master where code='retrieve_infra_by_role_location';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_infra_by_role_location','locationIds,roleId','select r.name as rolename,h.type as type, h.name as infrastructureName,h.id, h.location_id as locationId from health_infrastructure_details h ,um_role_master r  ,
 role_health_infrastructure_type  rh
 where h.type = rh.health_infrastructure__type_id and r.id= rh.role_id
 and (''#locationIds#'' = ''null'' or location_id IN (#locationIds#)  ) and rh.state=''ACTIVE'' and r.id=#roleId#',true,'ACTIVE','Retrieve infrastructure by role and location');

delete from query_master where code='retrieve_health_infra_for_user';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_health_infra_for_user','userId','
select  h.name , h.id,h.type as type from health_infrastructure_details  h
 ,user_health_infrastructure  u
 where u.health_infrastrucutre_id=h.id and user_id=''#userId#'' and u.state=''ACTIVE''',true,'ACTIVE','Retrieve Health Infrastructure for the user id');

delete from query_master where code='retrieve_roles_for_health_infra_type';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_roles_for_health_infra_type','infraType','
select r.id ,r.name from  um_role_master r
 ,role_health_infrastructure_type  rh
 where rh.role_id=r.id and r.state=''ACTIVE'' and rh.health_infrastructure__type_id=#infraType#
',true,'ACTIVE','Retrieve Roles for the health infrastructure type');

delete from query_master where code='retrieve_users_for_infra_role';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_users_for_infra_role','healthInfraId,code','
select u.first_name,u.user_name,u.last_name,u.id from um_user  u, user_health_infrastructure  uh, um_role_master r where uh.user_id=u.id and uh.health_infrastrucutre_id =#healthInfraId# and uh.state=''ACTIVE'' 
 and r.code=''#code#''
',true,'ACTIVE','Retrieve Users for the particular infra and role');
