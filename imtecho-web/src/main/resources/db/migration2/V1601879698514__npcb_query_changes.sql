DELETE FROM QUERY_MASTER WHERE CODE='retrieve_npcb_hospitals_by_infra_type';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'994c6655-97bd-41ac-8c8c-a598cb448283', 60512,  current_date , 60512,  current_date , 'retrieve_npcb_hospitals_by_infra_type',
'infraType',
'select * from health_infrastructure_details where type = #infraType#
and is_npcb',
null,
true, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='npcb_screened_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
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
	and diabetes.status in (''REFERRED'',''CONFIRMED'',''TREATMENT_STARTED'')
	left join ncd_member_diseases_diagnosis hypertension on details."memberId" = hypertension.member_id
	and hypertension.disease_code = ''HT''
	and hypertension.status in (''REFERRED'',''CONFIRMED'',''TREATMENT_STARTED'')
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

DELETE FROM QUERY_MASTER WHERE CODE='npcb_examined_details_retrieve';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
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
	and diabetes.status in (''REFERRED'',''CONFIRMED'',''TREATMENT_STARTED'')
	left join ncd_member_diseases_diagnosis hypertension on details."memberId" = hypertension.member_id
	and hypertension.disease_code = ''HT''
	and hypertension.status in (''REFERRED'',''CONFIRMED'',''TREATMENT_STARTED'')
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