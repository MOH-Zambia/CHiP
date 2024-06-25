delete from QUERY_MASTER where CODE='npcb_screened_details_retrieve';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'a3608a4d-54a3-4ac1-9e78-e7d89e76d778', 60512,  current_date , 60512,  current_date , 'npcb_screened_details_retrieve',
'id',
'with details as (
	select imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.dob as "dob",
	imt_family.bpl_flag as "bplFlag",
	imt_family.area_id,
	imt_member.gender as gender,
	listvalue_field_value_detail.value as caste,
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	imt_member.family_id as "familyId",
	get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
	npcb_member_screening_master.*
	from npcb_member_screening_master
	inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
	where npcb_member_screening_master.id = #id#
),asha_details as (
	select details."memberId",
	concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaContactNumber"
	from details
	inner join um_user_location on details.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
	inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
),ncd_details as (
	select details."memberId",
	case when diabetes.id is not null then true else false end as "hasDiabetes",
	case when hypertension.id is not null then true else false end as "hasHypertension"
	from details
	left join ncd_member_diseases_diagnosis diabetes on details."memberId" = diabetes.member_id
	and diabetes.disease_code = ''D''
	and diabetes.status in (''REFERRED'',''CONFIRMED'')
	left join ncd_member_diseases_diagnosis hypertension on details."memberId" = hypertension.member_id
	and hypertension.disease_code = ''HT''
	and hypertension.status in (''REFERRED'',''CONFIRMED'')
)select details.*,
asha_details."ashaName",
asha_details."ashaContactNumber",
ncd_details."hasDiabetes",
ncd_details."hasHypertension"
from details
left join asha_details on details."memberId" = asha_details."memberId"
left join ncd_details on details."memberId" = ncd_details."memberId"',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='npcb_examined_details_retrieve';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'84ee50d3-2b0b-4f8e-8b35-fb4a6b1df8d4', 60512,  current_date , 60512,  current_date , 'npcb_examined_details_retrieve',
'id',
'with details as (
	select imt_member.id as "memberId",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.dob as "dob",
	imt_family.bpl_flag as "bplFlag",
	imt_family.area_id,
	imt_member.gender as gender,
	listvalue_field_value_detail.value as caste,
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
	imt_member.family_id as "familyId",
	get_location_hierarchy(imt_family.area_id) as "locationHierarchy",
	npcb_member_examination_detail.screening_id,
	npcb_member_examination_detail.id as "previousExamineId",
	npcb_member_screening_master.*
	from npcb_member_examination_detail
	inner join npcb_member_screening_master on npcb_member_examination_detail.screening_id = npcb_member_screening_master.id
	inner join imt_member on npcb_member_screening_master.member_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as text)
	where npcb_member_examination_detail.id = #id#
),asha_details as (
	select details."memberId",
	concat(um_user.first_name,'' '',um_user.last_name) as "ashaName",
	um_user.contact_number as "ashaContactNumber"
	from details
	inner join um_user_location on details.area_id = um_user_location.loc_id and um_user_location.state = ''ACTIVE''
	inner join um_user on um_user_location.user_id = um_user.id and role_id = 24 and um_user.state = ''ACTIVE''
),ncd_details as (
	select details."memberId",
	case when diabetes.id is not null then true else false end as "hasDiabetes",
	case when hypertension.id is not null then true else false end as "hasHypertension"
	from details
	left join ncd_member_diseases_diagnosis diabetes on details."memberId" = diabetes.member_id
	and diabetes.disease_code = ''D''
	and diabetes.status in (''REFERRED'',''CONFIRMED'')
	left join ncd_member_diseases_diagnosis hypertension on details."memberId" = hypertension.member_id
	and hypertension.disease_code = ''HT''
	and hypertension.status in (''REFERRED'',''CONFIRMED'')
)select details.*,
asha_details."ashaName",
asha_details."ashaContactNumber",
ncd_details."hasDiabetes",
ncd_details."hasHypertension"
from details
left join asha_details on details."memberId" = asha_details."memberId"
left join ncd_details on details."memberId" = ncd_details."memberId"',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='npcb_spectacles_list_retrieve';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'cc1455ff-7b34-4bbd-af0b-3932d1efc01b', 60512,  current_date , 60512,  current_date , 'npcb_spectacles_list_retrieve',
'healthInfrastructureId,offSet,limit',
'with member_ids as (
	select id,member_id,service_date,re_axis,re_cyl,le_axis,le_cyl from npcb_member_examination_detail
	where health_infrastructure_id = #healthInfrastructureId#
	and spectacles_given
	and spectacles_given_date is null
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
inner join imt_family on imt_member.family_id = imt_family.family_id',
null,
true, 'ACTIVE');