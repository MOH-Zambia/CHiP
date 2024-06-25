delete from query_master where code='cerebral_palsy_retrieve_by_id';
delete from query_master where code='cerebral_palsy_update_remarks_and_status';
delete from query_master where code='cerebral_palsy_update_remarks';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'cerebral_palsy_retrieve_by_id','id','
with member_details as
(select * from rch_child_cp_suspects where child_service_id = #id#)
select t1.id,t1.unique_health_id,t1.family_id,um.first_name as "FHWName",um.contact_number as "FHWNumber",t1.additional_info as "additionalInfo",
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
values(1,current_date,'cerebral_palsy_update_remarks_and_status','id,remarks,remarksDate,status,additionalInfo,childId','
update rch_child_cp_suspects
set remarks = ''#remarks#'', status=''#status#'', remarks_date = ''#remarksDate#''
where child_service_id = #id#;
update imt_member
set additional_info = ''#additionalInfo#'' where id = #childId#
',false,'ACTIVE');