
CREATE TABLE public.um_role_category
(
   role_id bigint, 
   category_id bigint, 
   id bigserial, 
   created_by bigint, 
   created_on timestamp without time zone,
   modified_by bigint, 
   modified_on timestamp without time zone,
state character varying(200)
) 
WITH (
  OIDS = FALSE
)
;

INSERT INTO public.listvalue_field_master(
            field_key, field, is_active, field_type, form)
    VALUES ('role_catg', 'Role Category', true, 'T', 'WEB');


INSERT INTO public.listvalue_field_value_detail(
             is_active, is_archive, last_modified_by, last_modified_on, 
            value, field_key, file_size,  code)
    VALUES ( true, false,'superadmin', now(), 
            'Doctor', 'role_catg', 0,'DOCTOR');

            INSERT INTO public.listvalue_field_value_detail(
             is_active, is_archive, last_modified_by, last_modified_on, 
            value, field_key, file_size,  code)
    VALUES ( true, false,'superadmin', now(), 
            'ANM', 'role_catg', 0,'ANM');

            INSERT INTO public.listvalue_field_value_detail(
             is_active, is_archive, last_modified_by, last_modified_on, 
            value, field_key, file_size,  code)
    VALUES ( true, false,'superadmin', now(), 
            'Staff Nurse', 'role_catg', 0,'STAFF_NURSE');

            INSERT INTO public.listvalue_field_value_detail(
             is_active, is_archive, last_modified_by, last_modified_on, 
            value, field_key, file_size,  code)
    VALUES ( true, false,'superadmin', now(), 
            'TBA', 'role_catg', 0,'TBA');

            INSERT INTO public.listvalue_field_value_detail(
             is_active, is_archive, last_modified_by, last_modified_on, 
            value, field_key, file_size,  code)
    VALUES ( true, false,'superadmin', now(), 
            'NON TBA', 'role_catg', 0,'NON_TBA');      


delete from query_master where code='retrieve_users_for_infra_role';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state,description)
values(1,now(),'retrieve_users_for_infra_role','healthInfraId,code','
select  u.first_name,u.user_name,u.last_name,u.id  from  um_user u,user_health_infrastructure uh, um_role_master r , um_role_category rc,
 listvalue_field_value_detail   l
 where uh.user_id=u.id and u.role_id = r.id and rc.role_id= r.id and  rc.category_id=l.id  and l.field_key=''role_catg'' and l.code=''#code#'' and uh.health_infrastrucutre_id=#healthInfraId# and uh.state=''ACTIVE''
',true,'ACTIVE','Retrieve Users for the particular infra and role');


