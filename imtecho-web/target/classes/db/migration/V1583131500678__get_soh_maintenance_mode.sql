delete from query_master where code='get_soh_maintenance_mode';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_soh_maintenance_mode','systemKey','
select
	is_active,
	key_value
from
	system_configuration
where
	system_key = ''#systemKey#''
',true,'ACTIVE');