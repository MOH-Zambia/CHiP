update query_master
set query = '
with member_ids as (
	select id,member_id,service_date,re_axis,re_cyl,le_axis,le_cyl from npcb_member_examination_detail
	where spectacles_given and spectacles_given_date is null
	and health_infrastructure_id = #healthInfrastructureId#
	order by service_date desc
	limit #limit# offset #offSet#
)
select
member_ids.id as "id",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
member_ids.re_axis as "re_axis",
member_ids.re_cyl as "re_cyl",
member_ids.le_axis as "le_axis",
member_ids.le_cyl as "le_cyl",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
member_ids.service_date as "serviceDate"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
', params = 'healthInfrastructureId,offSet,limit'
where code = 'npcb_spectacles_list_retrieve';
