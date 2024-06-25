delete from query_master where code='dr_techo_rbsk_child_search_by_member_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'dr_techo_rbsk_child_search_by_member_id','uniqueHealthId','
select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	concat( mother.first_name, '' '', mother.middle_name, '' '', mother.last_name ) as "motherName"
from
	imt_member child
inner join imt_member mother on
	child.mother_id = mother.id
where
	child.unique_health_id in ( ''#uniqueHealthId#'' )
',true,'ACTIVE');


delete from query_master where code='dr_techo_rbsk_child_search_by_family_id';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'dr_techo_rbsk_child_search_by_family_id','familyId','
select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	concat( mother.first_name, '' '', mother.middle_name, '' '', mother.last_name ) as "motherName"
from
	imt_member child
inner join imt_member mother on
	child.mother_id = mother.id
where
	child.family_id in ( ''#familyId#'' )
',true,'ACTIVE');

delete from query_master where code='dr_techo_rbsk_child_search_by_mobile_number';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'dr_techo_rbsk_child_search_by_mobile_number','uniqueHealthId','
with mother_details as ( select
	id, unique_health_id, mobile_number, concat( first_name, '' '', middle_name, '' '', last_name ) as mother_name
from
	imt_member
where
	mobile_number in ( ''#mobileNumber#'' ) ) select
	child.id as "memberId",
	child.unique_health_id as "uniqueHealthId",
	child.first_name as "firstName",
	child.middle_name as "middleName",
	child.last_name as "lastName",
	child.family_id as "familyId",
	child.gender,
	child.dob,
	child.birth_weight as "weight",
	mother.unique_health_id as "motherId",
	mother.mobile_number as "motherPhoneNumber",
	mother.mother_name as "motherName"
from
	imt_member child
inner join mother_details mother on
	child.mother_id = mother.id
where
	child.mother_id in ( select
		id
	from
		mother_details )
',true,'ACTIVE');

