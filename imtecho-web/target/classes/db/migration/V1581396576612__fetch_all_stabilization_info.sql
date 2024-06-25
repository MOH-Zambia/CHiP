delete from query_master where code='get_all_stabilization_info';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_all_stabilization_info','','
select * from rbsk_defect_stabilization_info
',true,'ACTIVE');