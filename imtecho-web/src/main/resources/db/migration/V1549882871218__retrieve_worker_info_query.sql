delete from query_master where code='retrieve_worker_info_by_location_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_worker_info_by_location_id','locationId','
select CAST(json_agg(json_build_object(''name'',CONCAT(u.first_name,'' '',u.last_name),''mobileNumber'',u.contact_number)) as text) as "workerDetails"
from um_user u, um_user_location ul where u.id = ul.user_id and ul.state = ''ACTIVE'' and u.state = ''ACTIVE'' and ul.loc_id = #locationId#;
',true,'ACTIVE');