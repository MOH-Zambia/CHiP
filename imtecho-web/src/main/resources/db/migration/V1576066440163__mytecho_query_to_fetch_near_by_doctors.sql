DELETE FROM query_master where code='mytecho_doctors_near_me_retrieval';

INSERT INTO public.query_master
(created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'mytecho_doctors_near_me_retrieval', 'pincode',
'with um_doctor_user as (
 	select um_user.id, um_user.pincode,um_user.first_name,  um_user.last_name , um_user.gender  from public.um_user um_user where um_user.role_id = 203 and um_user.pincode >= (#pincode# - 2) and um_user.pincode <= (#pincode# + 2)
 )
 select
 um_doctor_user.id as id,
 um_doctor_user.pincode as pincode,
 um_doctor_user.first_name as "firstName" ,
 um_doctor_user.last_name as "lastName",
 um_doctor_user.gender as gender,
 hi_detail.address as address,
 hi_detail.mobile_number as "mobileNumber",
 hi_detail.landline_number as "landLineNumber",
 hi_detail.email as email,
 hi_detail.latitude as latitude,
 hi_detail.longitude as longitude
 from  um_doctor_user
 inner join user_health_infrastructure health_infrastructure on health_infrastructure.user_id = um_doctor_user.id
 inner join health_infrastructure_details hi_detail on hi_detail.id = health_infrastructure.health_infrastrucutre_id;'
 , true, 'ACTIVE', NULL);
