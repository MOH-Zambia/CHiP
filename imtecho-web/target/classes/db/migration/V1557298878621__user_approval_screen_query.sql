insert into menu_config (feature_json,active,menu_name,navigation_state,menu_type)
values('{}',true,'State Of Health User Approval','techo.manage.userhealthapproval','manage');

delete from query_master where code='retrieve_user_for_health_approval';

insert into query_master(created_by,created_on,code, params,query,returns_result_set,state)
values(1,current_date,'retrieve_user_for_health_approval','state',
'select * from soh_user where state = ''#state#''',true,'ACTIVE');



