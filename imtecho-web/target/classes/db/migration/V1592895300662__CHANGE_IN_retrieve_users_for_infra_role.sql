DELETE FROM QUERY_MASTER WHERE CODE='retrieve_users_for_infra_role';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'664f0e06-9f64-4e55-9e0e-a072c9b33be6', 75398,  current_date , 75398,  current_date , 'retrieve_users_for_infra_role', 
'healthInfraId,code', 
'select  u.first_name,u.user_name,u.last_name,u.id  from  um_user u,user_health_infrastructure uh, um_role_master r , um_role_category rc,
 listvalue_field_value_detail   l
 where uh.user_id=u.id and u.role_id = r.id and rc.role_id= r.id and  rc.category_id=l.id  and l.field_key=''role_catg'' and (case when #code#=null then l.code in (''DOCTOR'',''ANM'',''STAFF_NURSE'',''TBA'',''NON_TBA'') else l.code = #code# end) and uh.health_infrastrucutre_id=#healthInfraId# and uh.state=''ACTIVE''', 
'Retrieve Users for the particular infra and role', 
true, 'ACTIVE');