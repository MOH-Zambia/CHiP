delete from query_master where code = 'get_rch_register_eligible_couple_service_basic_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_eligible_couple_service_basic_info','location_id,to_date,from_date,limit,offset,serviceType','
with test as (select cast( json_agg(t) as text) as lmp_visit_info from (select ''01-01-2019'' as date, ''IOCD'' as contraception_method  from imt_family limit 12)t)
select 
cast(''20035660'' as text) as member_unique_health_id,
cast(''1986-06-03'' as text)  as registration_date,
cast(''Akshar'' as text) as  member_name,
20 as member_current_age,
15 as  member_marriage_age,
cast(''Akshar'' as text) as husband_name,
20 as husband_current_age,
15 as  husband_marriage_age,
cast(''Argusoft'' as text) as address,
cast(''Hindu'' as text) as religion,
cast(''test'' as text) as cast,
cast(''AVL'' as text) as bpl_apl,
2 as total_given_male_birth,
3 as total_given_female_birth,
3 as live_male_birth,
3 as live_female_birth,
2 as smallest_child_age,
cast(''Male'' as text) as smallest_child_gender,
cast((select lmp_visit_info from test) as text) as lmp_visit_info
from imt_member limit 100
',true,'ACTIVE');



delete from query_master where code = 'get_rch_register_eligible_couple_service_detailed_info';
insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_rch_register_eligible_couple_service_detailed_info','member_id','
with test as (select cast( json_agg(t) as text) as lmp_visit_info from (select ''01-01-2019'' as date, ''IOCD'' as contraception_method  from imt_family limit 12)t)
select 
cast(''20035660'' as text) as member_unique_health_id,
cast(''1986-06-03'' as text)  as registration_date,
cast(''Akshar'' as text) as  member_name,
20 as member_current_age,
15 as  member_marriage_age,
cast(''Akshar'' as text) as husband_name,
20 as husband_current_age,
15 as  husband_marriage_age,
cast(''Argusoft'' as text) as address,
cast(''Hindu'' as text) as religion,
cast(''test'' as text) as cast,
cast(''AVL'' as text) as bpl_apl,
2 as total_given_male_birth,
3 as total_given_female_birth,
3 as live_male_birth,
3 as live_female_birth,
2 as smallest_child_age,
cast(''Male'' as text) as smallest_child_gender,
cast((select lmp_visit_info from test) as text) as lmp_visit_info
from imt_member limit 100
',true,'ACTIVE');




