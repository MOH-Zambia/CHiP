delete from QUERY_MASTER where CODE='npcb_screened_list_retrieve';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'2daa2337-30e1-48ba-9236-bafa1f2c5d43', 60512,  current_date , 60512,  current_date , 'npcb_screened_list_retrieve',
'healthInfrastructureId,offSet,limit',
'with member_ids as (
	select id,member_id
	from npcb_member_screening_master
	where health_infrastructure_id = #healthInfrastructureId#
	and is_examined is null
	limit #limit# offset #offSet#
),asha_details as (
	select member_ids.member_id,
	concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaContactNumber"
	from member_ids
	inner join imt_member on imt_member.id = member_ids.member_id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location on imt_family.area_id = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	inner join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	and role_id = 24
)
select
member_ids.id as "id",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
asha_details."ashaName",
asha_details."ashaContactNumber"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join asha_details on member_ids.member_id = asha_details.member_id',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='npcb_examined_list_retrieve';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'9542430c-ca3c-41e0-bde2-3144a85717d3', 60512,  current_date , 60512,  current_date , 'npcb_examined_list_retrieve',
'healthInfrastructureId,offSet,limit',
'with member_ids as (
	select id,member_id,screening_id from npcb_member_examination_detail
	where referral_health_infrastructure = #healthInfrastructureId#
	and examine_id is null
	limit #limit# offset #offSet#
),asha_details as (
	select member_ids.member_id,
	concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaContactNumber"
	from member_ids
	inner join imt_member on imt_member.id = member_ids.member_id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location on imt_family.area_id = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	inner join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	and role_id = 24
)
select
member_ids.id as "id",
member_ids.screening_id as "screeningId",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
asha_details."ashaName",
asha_details."ashaContactNumber"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join asha_details on member_ids.member_id = asha_details.member_id',
null,
true, 'ACTIVE');