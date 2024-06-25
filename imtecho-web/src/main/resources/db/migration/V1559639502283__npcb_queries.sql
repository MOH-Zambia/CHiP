alter table npcb_member_screening_master
drop column if exists is_examined,
drop column if exists examine_id,
add column is_examined boolean,
add column examine_id bigint;

alter table npcb_member_examination_detail
drop column if exists screening_id,
drop column if exists examine_id,
drop column if exists spectacles_given,
drop column if exists other_diseases_details,
add column screening_id bigint,
add column examine_id bigint,
add column spectacles_given boolean,
add column other_diseases_details text;


delete from query_master where code='npcb_list_retrieve';
delete from query_master where code='npcb_details_retrieve';
delete from query_master where code='npcb_screened_list_retrieve';
delete from query_master where code='npcb_examined_list_retrieve';
delete from query_master where code='npcb_screened_details_retrieve';
delete from query_master where code='npcb_examined_details_retrieve';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_screened_list_retrieve','healthInfrastructureId,limit,offSet','
with member_ids as (
	select id,member_id from npcb_member_screening_master
	where health_infrastructure_id = #healthInfrastructureId#
	and is_examined is null
	limit #limit# offset #offSet#
)
select
member_ids.id as "id",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_examined_list_retrieve','healthInfrastructureId,limit,offSet','
with member_ids as (
	select id,member_id,screening_id from npcb_member_examination_detail
	where (cataract_health_infrastructure_id = #healthInfrastructureId# or other_issues_health_infrastructure_id = #healthInfrastructureId#)
	and examine_id is null
	limit #limit# offset #offSet#
)
select
member_ids.id as "id",
member_ids.screening_id as "screeningId",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_screened_details_retrieve','id','
select
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
npcb_member_screening_master.*
from npcb_member_screening_master 
inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
where npcb_member_screening_master.id = #id#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_examined_details_retrieve','id','
select
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
npcb_member_examination_detail.screening_id,
npcb_member_examination_detail.id as "previousExamineId",
npcb_member_screening_master.*
from npcb_member_examination_detail
inner join npcb_member_screening_master on npcb_member_examination_detail.screening_id = npcb_member_screening_master.id
inner join imt_member on npcb_member_examination_detail.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
where npcb_member_examination_detail.id = #id#
',true,'ACTIVE');