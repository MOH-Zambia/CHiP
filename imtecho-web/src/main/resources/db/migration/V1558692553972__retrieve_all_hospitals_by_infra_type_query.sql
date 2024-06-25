delete from query_master where code='retrieve_all_hospitals_by_infra_type';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_all_hospitals_by_infra_type','infraType','
select * from health_infrastructure_details where type = #infraType# and state = ''ACTIVE''
',true,'ACTIVE');