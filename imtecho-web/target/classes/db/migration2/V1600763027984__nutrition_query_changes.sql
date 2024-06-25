DELETE FROM QUERY_MASTER WHERE CODE='child_cmtc_nrc_discharge_list';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'cd670c5e-b05a-4c0a-9899-2281f3718d69', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_discharge_list',
'offset,limit,userId',
'with child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id,
	child_cmtc_nrc_screening_detail.admission_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DISCHARGE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.discharge_id is not null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name) as asha_name,
	asha.contact_number as asha_contact_number
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
),follow_up_detail as (
	select child_cmtc_nrc_follow_up.admission_id,max(child_cmtc_nrc_follow_up.id) as follow_up_id
	from child_ids
	inner join child_cmtc_nrc_follow_up on child_ids.admission_id = child_cmtc_nrc_follow_up.admission_id
	group by child_cmtc_nrc_follow_up.admission_id
)
select child_cmtc_nrc_screening_detail.id,
child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
child_cmtc_nrc_screening_detail.child_id as "memberId",
child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
child_cmtc_nrc_screening_detail.state as "state",
child_cmtc_nrc_screening_detail.admission_id as "admissionId",
child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
child_cmtc_nrc_screening_detail.created_by as "createdBy",
child_cmtc_nrc_screening_detail.identified_from as "identifiedFrom",
health_infrastructure_details.name as "healthInfrastructureName",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.unique_health_id as "uniqueHealthId",
imt_member.family_id as "familyId",
imt_member.dob as "dob",
imt_member.gender as "gender",
imt_family.bpl_flag as "bplFlag",
listvalue_field_value_detail.value as "caste",
concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
mother.mobile_number as "motherContactNumber",
concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name) as "referredByName",
um_user.contact_number as "referredByContactNumber",
asha_detail.asha_name as "ashaName",
asha_detail.asha_contact_number as "ashaContactNumber",
location.name as "villageName",
area.name as "areaName",
child_cmtc_nrc_discharge_detail.discharge_date as "dischargeDate",
child_cmtc_nrc_follow_up.follow_up_visit as "lastFollowUpVisitNo",
child_cmtc_nrc_follow_up.follow_up_date as "lastFollowUpDate"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join child_cmtc_nrc_discharge_detail on child_cmtc_nrc_screening_detail.discharge_id = child_cmtc_nrc_discharge_detail.id
left join follow_up_detail on child_cmtc_nrc_screening_detail.admission_id = follow_up_detail.admission_id
left join child_cmtc_nrc_follow_up on follow_up_detail.follow_up_id = child_cmtc_nrc_follow_up.id
inner join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
left join imt_member mother on imt_member.mother_id = mother.id
inner join imt_family on imt_member.family_id = imt_family.family_id
left join location_master location on imt_family.location_id = location.id
left join location_master area on imt_family.area_id = area.id
left join listvalue_field_value_detail on imt_family.caste = cast(listvalue_field_value_detail.id as character varying)
left join um_user on child_cmtc_nrc_screening_detail.created_by = um_user.id
left join asha_detail on child_cmtc_nrc_screening_detail.id = asha_detail.id
order by child_cmtc_nrc_screening_detail.id desc',
null,
true, 'ACTIVE');