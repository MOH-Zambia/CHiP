delete from query_master where code='update_stabilization_info_status';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'update_stabilization_info_status','code,status','
update
	rbsk_defect_stabilization_info
set
	status = ''#status#''
where
	code = ''#code#''
',false,'ACTIVE');