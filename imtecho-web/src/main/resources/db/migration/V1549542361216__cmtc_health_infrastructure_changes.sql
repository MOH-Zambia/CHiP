delete from query_master where code='retrieve_screening_centers_cmtc';
delete from query_master where code='child_cmtc_nrc_screened_list';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_screening_centers_cmtc','userId','
select * from health_infrastructure_details
where id in (select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
and is_cmtc = true
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'child_cmtc_nrc_screened_list','userId','
select row_number() over (ORDER BY csd.id)as "Sr. No", csd.id,
m.first_name || '' '' || m.middle_name || '' '' || m.last_name as "Child Name",
m2.first_name || '' '' || m2.middle_name || '' '' || m2.last_name as "Mother Name",
l.name as "Asha Area", l1.name as "Village",
u.first_name || '' '' || u.last_name as "Referred By",
csd.child_id, csd.screened_on, csd.state,csd.admission_id,csd.discharge_id, csd.created_by
from child_cmtc_nrc_screening_detail csd inner join imt_member m on csd.child_id = m.id 
left join imt_member m2 on m.mother_id = m2.id
inner join location_master l on csd.location_id = l.id
inner join location_master l1 on l1.id = l.parent
inner join um_user u on u.id = csd.created_by
where 
csd.location_id in 
(select child_id from location_hierchy_closer_det where parent_id in 
(select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''))
and (csd.screening_center is null or csd.screening_center in 
(select id from health_infrastructure_details where id in 
(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
and is_cmtc = true))
',true,'ACTIVE');

alter table child_cmtc_nrc_admission_detail
drop column if exists screening_center,
add column screening_center bigint;