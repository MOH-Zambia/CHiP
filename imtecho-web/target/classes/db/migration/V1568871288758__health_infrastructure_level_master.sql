delete from health_infrastructure_type_location;

insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1062,6);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1061,5);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1063,5);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1009,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1008,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1013,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1010,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1064,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1084,4);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1007,3);
insert into health_infrastructure_type_location (health_infra_type_id,location_level) values (1012,3);

alter table rch_wpd_mother_master
drop column if exists referral_infra_id,
add column referral_infra_id bigint;

alter table rch_wpd_child_master
drop column if exists referral_infra_id,
add column referral_infra_id bigint;

delete from query_master where code='retrieve_health_infra_by_level';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_health_infra_by_level','filter,infrastructureType','
with details as (
	select location_level from health_infrastructure_type_location where health_infra_type_id = #infrastructureType#
)select health_infra_type_id 
from health_infrastructure_type_location,details where 
case when ''#filter#'' = ''U'' then health_infrastructure_type_location.location_level <= details.location_level
	 when ''#filter#'' = ''L'' then health_infrastructure_type_location.location_level >= details.location_level
end;
',true,'ACTIVE');

delete from query_master where code='retrieve_hospitals_by_infra_type';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_hospitals_by_infra_type','infraType','
select * from health_infrastructure_details where type = #infraType#
',true,'ACTIVE');

