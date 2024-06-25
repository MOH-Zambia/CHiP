alter table rch_child_cp_suspects
drop column if exists remarks,
add column remarks text;

delete from query_master where code='cerebral_palsy_list_retrieve';
delete from query_master where code='cerebral_palsy_retrieve_by_id';
delete from query_master where code='cerebral_palsy_retrieve_immunisation_by_id';
delete from query_master where code='cerebral_palsy_retrieve_anc_danger_signs_by_id';
delete from query_master where code='cerebral_palsy_retrieve_delivery_place_by_id';
delete from query_master where code='cerebral_palsy_retrieve_pnc_danger_signs_by_id';
delete from query_master where code='cerebral_palsy_retrieve_wpd_danger_signs_by_id';
delete from query_master where code='retrieve_location_hierarchy_by_location_id';
delete from query_master where code='cerebral_palsy_module_check';
delete from query_master where code='cerebral_palsy_update_remarks';
delete from query_master where code='retrieve_previous_cp_data';
delete from query_master where code='check_last_cp_status';
delete from query_master where code='retrieve_last_cp_questions_list';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_list_retrieve','userId,limit,offSet','
with ids as (
	select max(id) from rch_child_cp_suspects where location_id in (
		select child_id from location_hierchy_closer_det where parent_id in (
			select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE''
		)
	)
	group by rch_child_cp_suspects.member_id
	limit #limit# offset #offSet#
), member_details as (
	select * from rch_child_cp_suspects where id in (
		select * from ids
	)
)
select t1.id,t3.area_id,member_details.location_id,member_details.child_service_id,member_details.status,
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
t2.mobile_number
from member_details
inner join imt_member t1 on t1.id = member_details.member_id
inner join imt_member t2 on t1.mother_id = t2.id
inner join imt_family t3 on t1.family_id = t3.family_id
left join um_user_location ula on t3.area_id = ula.loc_id and ula.state=''ACTIVE''
left join um_user uma on ula.user_id = uma.id and uma.role_id = 24 and uma.state = ''ACTIVE''
inner join um_user_location ul on member_details.location_id = ul.loc_id and ul.state = ''ACTIVE''
inner join um_user um on ul.user_id = um.id and um.role_id = 30 and um.state = ''ACTIVE''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_by_id','id','
with member_details as
(select * from rch_child_cp_suspects where child_service_id = #id#)
select t1.id,t1.unique_health_id,t1.family_id,um.first_name as "FHWName",um.contact_number as "FHWNumber",
childService.service_date as "childServiceDate",
t3.area_id,member_details.location_id,
uma.first_name as "ashaName",
uma.contact_number as "ashaNumber",
t1.first_name as "childFirstName",
t1.last_name as "childLastName",
t1.middle_name as "childMiddleName",
t1.dob,
t2.first_name as "motherFirstName",
t2.middle_name as "motherMiddleName",
t2.last_name as "motherLastName",
t2.mobile_number
from member_details
inner join imt_member t1 on t1.id = member_details.member_id
inner join imt_member t2 on t1.mother_id = t2.id
inner join imt_family t3 on t1.family_id = t3.family_id
left join um_user_location ula on t3.area_id = ula.loc_id and ula.state=''ACTIVE''
left join um_user uma on ula.user_id = uma.id and uma.role_id = 24 and uma.state = ''ACTIVE''
inner join um_user_location ul on member_details.location_id = ul.loc_id and ul.state = ''ACTIVE''
inner join um_user um on ul.user_id = um.id and um.role_id = 30 and um.state = ''ACTIVE''
inner join rch_child_service_master childService on childService.id = member_details.child_service_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_immunisation_by_id','id','
select * from rch_immunisation_master where pregnancy_reg_det_id = 
(select pregnancy_reg_det_id from rch_wpd_mother_master where id = 
(select wpd_mother_id from rch_wpd_child_master where member_id = #id#))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_anc_danger_signs_by_id','id','
select string_agg(value,'','') as "ancDangerSigns" from listvalue_field_value_detail where id in (select distinct rch_anc_dangerous_sign_rel.dangerous_sign_id
from rch_anc_dangerous_sign_rel where anc_id in (
	select id from rch_anc_master where pregnancy_reg_det_id in (
		select pregnancy_reg_det_id from rch_wpd_mother_master where id in (
			select wpd_mother_id from rch_wpd_child_master where member_id = #id#
		)
	)
)) and is_active = true
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_delivery_place_by_id','id','
select delivery_place,type_of_delivery from rch_wpd_mother_master where id =
(select wpd_mother_id from rch_wpd_child_master where member_id = #id#)
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_pnc_danger_signs_by_id','id','
select string_agg(value,'','') as "pncDangerSigns" from listvalue_field_value_detail where id in
(select distinct child_danger_signs from rch_pnc_child_danger_signs_rel where child_pnc_id in 
(select id from rch_pnc_child_master where child_id = ''#id#''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_wpd_danger_signs_by_id','id','
select string_agg(value,'','') as "wpdDangerSigns" from listvalue_field_value_detail where id in
(select distinct danger_signs from rch_wpd_child_danger_signs_rel where wpd_id in 
(select id from rch_wpd_child_master where member_id = ''#id#''))
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_location_hierarchy_by_location_id','locationId','
select string_agg(l2.name,''>'' order by lhcd.depth desc) as location_id
from location_master l1 
inner join location_hierchy_closer_det lhcd on lhcd.child_id = l1.id
inner join location_master l2 on l2.id = lhcd.parent_id
where l1.id = #locationId#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_module_check','locationId','
select cerebral_palsy_module from location_master where id in
(select parent_id from location_hierchy_closer_det where child_id = #locationId# and parent_loc_type = ''D'')
and state = ''ACTIVE''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_update_remarks','remarks,memberId','
update rch_child_cp_suspects
set remarks = ''#remarks#'', status=''#status#'', remarks_date = ''#remarksDate#''
where child_service_id = #id#
',false,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_previous_cp_data','id,childServiceId','
select status,remarks,remarks_date from rch_child_cp_suspects where member_id = #id# and child_service_id != #childServiceId#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'check_last_cp_status','id','
select status from rch_child_cp_suspects where member_id = #id# order by id desc limit 1
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'retrieve_last_cp_questions_list','id','
select * from rch_child_cerebral_palsy_master where member_id = #id# order by id desc limit 1
',true,'ACTIVE');