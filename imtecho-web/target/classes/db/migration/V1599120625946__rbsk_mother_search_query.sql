DELETE FROM QUERY_MASTER WHERE CODE='mob_rbsk_child_search_by_mother_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'db6f4451-a16f-498d-9443-9cf34e3b09ef', 58981,  current_date , 58981,  current_date , 'mob_rbsk_child_search_by_mother_id', 
'health_id,userId', 
'with l as (
	select child_id from location_hierchy_closer_det where parent_id in (
		select ul.loc_id from um_user u 
		inner join um_user_location ul on u.id = ul.user_id	
		where u.state = ''ACTIVE'' and ul.state = ''ACTIVE''
		and u.id = #userId#
	)
)
select 
    child.id as child_id,
	child.unique_health_id,
	concat(child.first_name, '' '', child.last_name) as child_name,
	to_char(child.dob, ''DD/MM/YYYY'') as date_of_birth,
	child.gender,
	concat(mother.first_name, '' '', mother.last_name) as mother_name,
	mother.mobile_number,
	child.family_id as family_health_id,
    f.id as family_id,
    f.location_id,
	mother.unique_health_id as mother_id,
	child.birth_weight
from imt_member child
inner join imt_family f on child.family_id = f.family_id
inner join l on l.child_id = f.location_id
inner join imt_member mother on child.mother_id = mother.id
where child.dob > current_date - interval ''5 years'' and mother.unique_health_id = ''#health_id#''', 
null, 
true, 'ACTIVE');