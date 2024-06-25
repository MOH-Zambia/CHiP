delete from query_master where code='npcb_spectacles_list_retrieve';
delete from query_master where code='npcb_mark_as_spectacles_given';

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_spectacles_list_retrieve','limit,offSet','
with member_ids as (
	select id,member_id,service_date from npcb_member_examination_detail
	where spectacles_given and spectacles_given_date is null
	order by service_date desc
	limit #limit# offset #offSet#
)
select
member_ids.id as "id",
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
member_ids.service_date as "serviceDate"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'npcb_mark_as_spectacles_given','spectaclesGivenDate,id','
update npcb_member_examination_detail
set spectacles_given_date =  to_date(''#spectaclesGivenDate#'',''YYYY-MM-DD'')
where id = #id#
',false,'ACTIVE');