delete from query_master where code='cerebral_palsy_list_retrieve';
delete from query_master where code='cerebral_palsy_cp_list_retrieve';
delete from query_master where code='cerebral_palsy_status_list_retrieve';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_cp_list_retrieve','userId,limit,offSet','
with ids as (
	select max(rch_child_cp_suspects.id) from rch_child_cp_suspects
	inner join imt_member on imt_member.id = rch_child_cp_suspects.member_id
	where location_id in (
		select child_id from location_hierchy_closer_det where parent_id in (
			select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''
		)
	)
	and imt_member.mother_id is not null
	and status is null
	group by rch_child_cp_suspects.member_id
	limit #limit# offset #offSet#
), member_details as (
	select * from rch_child_cp_suspects
	inner join ids on rch_child_cp_suspects.id = ids.max
)
,hierarchy as (
	select member_details.member_id,
	string_agg(l2.name,''>'' order by lhcd.depth desc) as location_id
	from location_master l1 
	inner join member_details on member_details.location_id = l1.id
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = l1.id
	inner join location_master l2 on l2.id = lhcd.parent_id
	group by member_details.member_id
)select t1.id,t3.area_id,member_details.location_id,member_details.child_service_id,member_details.status,
uma.first_name as "ashaName",
uma.contact_number as "ashaNumber",
um.first_name as "FHWName",
um.contact_number as "FHWNumber", 
t1.first_name as "childFirstName",
t1.last_name as "childLastName",
t1.middle_name as "childMiddleName",
t1.dob,
t2.first_name as "motherFirstName",
t2.middle_name as "motherMiddleName",
t2.last_name as "motherLastName",
t2.mobile_number,
hierarchy.location_id as "locationHierarchy"
from member_details
inner join imt_member t1 on t1.id = member_details.member_id
inner join imt_member t2 on t1.mother_id = t2.id
inner join imt_family t3 on t1.family_id = t3.family_id
left join um_user_location ula on t3.area_id = ula.loc_id and ula.state=''ACTIVE''
left join um_user uma on ula.user_id = uma.id and uma.role_id = 24 and uma.state = ''ACTIVE''
inner join um_user_location ul on member_details.location_id = ul.loc_id and ul.state = ''ACTIVE''
inner join um_user um on ul.user_id = um.id and um.role_id = 30 and um.state = ''ACTIVE''
inner join hierarchy on member_details.member_id = hierarchy.member_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_status_list_retrieve','userId,limit,offSet','
with ids as (
	select max(rch_child_cp_suspects.id) from rch_child_cp_suspects
	inner join imt_member on imt_member.id = rch_child_cp_suspects.member_id
	where location_id in (
		select child_id from location_hierchy_closer_det where parent_id in (
			select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''
		)
	)
	and imt_member.mother_id is not null
	and status is not null
	group by rch_child_cp_suspects.member_id
	limit #limit# offset #offSet#
), member_details as (
	select * from rch_child_cp_suspects
	inner join ids on rch_child_cp_suspects.id = ids.max
)
,hierarchy as (
	select member_details.member_id,
	string_agg(l2.name,''>'' order by lhcd.depth desc) as location_id
	from location_master l1 
	inner join member_details on member_details.location_id = l1.id
	inner join location_hierchy_closer_det lhcd on lhcd.child_id = l1.id
	inner join location_master l2 on l2.id = lhcd.parent_id
	group by member_details.member_id
)select t1.id,t3.area_id,member_details.location_id,member_details.child_service_id,member_details.status,
uma.first_name as "ashaName",
uma.contact_number as "ashaNumber",
um.first_name as "FHWName",
um.contact_number as "FHWNumber", 
t1.first_name as "childFirstName",
t1.last_name as "childLastName",
t1.middle_name as "childMiddleName",
t1.dob,
t2.first_name as "motherFirstName",
t2.middle_name as "motherMiddleName",
t2.last_name as "motherLastName",
t2.mobile_number,
hierarchy.location_id as "locationHierarchy"
from member_details
inner join imt_member t1 on t1.id = member_details.member_id
inner join imt_member t2 on t1.mother_id = t2.id
inner join imt_family t3 on t1.family_id = t3.family_id
left join um_user_location ula on t3.area_id = ula.loc_id and ula.state=''ACTIVE''
left join um_user uma on ula.user_id = uma.id and uma.role_id = 24 and uma.state = ''ACTIVE''
inner join um_user_location ul on member_details.location_id = ul.loc_id and ul.state = ''ACTIVE''
inner join um_user um on ul.user_id = um.id and um.role_id = 30 and um.state = ''ACTIVE''
inner join hierarchy on member_details.member_id = hierarchy.member_id
',true,'ACTIVE');