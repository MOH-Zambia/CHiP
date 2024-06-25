update query_master
set query = '
select
imt_member.id as "memberId",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.dob as "dob",
imt_family.bpl_flag as "bplFlag",
case
	when imt_member.gender = ''M'' then ''Male''
	when imt_member.gender = ''F'' then ''Female''
	when imt_member.gender = ''T'' then ''Transgender''
	else imt_member.gender
end as gender,
(select value from listvalue_field_value_detail where cast(id as varchar) = imt_family.caste) as "caste",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.family_id as "familyId",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
um_user.contact_number as "ashaContactNumber",
ncd_member_hypertension_detail.member_id as "hypertensionId",
ncd_member_diabetes_detail.member_id as "diabetesId",
npcb_member_screening_master.*
from npcb_member_screening_master
inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
inner join um_user_location on imt_family.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
left join ncd_member_hypertension_detail on npcb_member_screening_master.member_id = ncd_member_hypertension_detail.member_id
and (ncd_member_hypertension_detail.systolic_bp>=140 or ncd_member_hypertension_detail.diastolic_bp >=90)
left join ncd_member_diabetes_detail on npcb_member_screening_master.member_id = ncd_member_diabetes_detail.member_id
and ncd_member_diabetes_detail.blood_sugar>140
where npcb_member_screening_master.id = #id#
' where code = 'npcb_screened_details_retrieve';

insert into query_master (created_by, created_on, code, params, returns_result_set, state, description, query)
 select 1, current_date, 'retrieve_npcb_health_infra_for_user', 'userId',true, 'ACTIVE', 'Retrieve NPCB Health Infrastructure for the user id',
'select  h.name , h.id,h.type as type from health_infrastructure_details h, user_health_infrastructure  u where u.health_infrastrucutre_id=h.id and user_id=''#userId#'' and is_npcb and u.state=''ACTIVE'''
 where not exists (select id from query_master qm where code = 'retrieve_npcb_health_infra_for_user');

update query_master
set query = '
with member_ids as (
	select id,member_id,service_date,re_axis,re_cyl,le_axis,le_cyl from npcb_member_examination_detail
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
member_ids.re_axis as "re_axis",
member_ids.re_cyl as "re_cyl",
member_ids.le_axis as "le_axis",
member_ids.le_cyl as "le_cyl",
get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
member_ids.service_date as "serviceDate"
from member_ids
inner join imt_member on imt_member.id = member_ids.member_id
inner join imt_family on imt_member.family_id = imt_family.family_id
' where code = 'npcb_spectacles_list_retrieve';