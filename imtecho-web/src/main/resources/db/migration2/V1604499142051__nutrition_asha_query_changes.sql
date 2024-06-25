delete from QUERY_MASTER where CODE='child_cmtc_nrc_screened_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'420a7bab-258f-4d88-b13a-38c558334451', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_screened_list',
'offset,limit,userId',
'with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''ACTIVE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.admission_id is null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
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
asha_detail.asha as "ashaDetails",
location.name as "villageName",
area.name as "areaName",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.muac else null end as "muac",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.sd_score else null end as "sdScore",
case when child_cmtc_nrc_screening_detail.identified_from = ''FHW'' then child_nutrition_sam_screening_master.have_pedal_edema else null end as "pedalEdema"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
left join child_nutrition_sam_screening_master on child_cmtc_nrc_screening_detail.reference_id = child_nutrition_sam_screening_master.id
and child_cmtc_nrc_screening_detail.identified_from = ''FHW''
left join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_admission_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'71e73bc3-8192-4f13-b4b5-947ee9ee9466', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_admission_list',
'offset,limit,userId',
'with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''ACTIVE''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and child_cmtc_nrc_screening_detail.admission_id is not null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
)
select imt_family.area_id,child_cmtc_nrc_screening_detail.id,
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
asha_detail.asha as "ashaDetails",
location.name as "villageName",
area.name as "areaName",
child_cmtc_nrc_admission_detail.admission_date as "admissionDate",
child_cmtc_nrc_admission_detail.no_of_times_amoxicillin_given as "noOfTimesAmoxicillinGiven",
child_cmtc_nrc_admission_detail.consecutive_3_days_weight_gain as "consecutive3DaysWeightGain"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join child_cmtc_nrc_admission_detail on child_cmtc_nrc_screening_detail.admission_id = child_cmtc_nrc_admission_detail.id
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_defaulter_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'4d586f48-4c39-4232-ba82-e24f6f9b30ad', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_defaulter_list',
'offset,limit,userId',
'with child_ids as (
	select child_cmtc_nrc_screening_detail.id,child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DEFAULTER''
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
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
asha_detail.asha as "ashaDetails",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_discharge_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
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
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
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
asha_detail.asha as "ashaDetails",
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_referred_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'feb23e39-583a-49dc-ab9d-b59d117e9a8a', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_referred_list',
'offset,limit,userId',
'with assigned_health_infrastructures as (
	select id from health_infrastructure_details where id in
	(select health_infrastrucutre_id from user_health_infrastructure where user_id = #userId# and state = ''ACTIVE'')
	and (is_cmtc or is_nrc or is_sncu)
),child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	where child_cmtc_nrc_screening_detail.referred_from is not null
	and child_cmtc_nrc_screening_detail.referred_to is not null
	and child_cmtc_nrc_screening_detail.is_case_completed is null
	and (
			(
				child_cmtc_nrc_screening_detail.referred_from in (select id from assigned_health_infrastructures)
				and child_cmtc_nrc_screening_detail.is_archive is null
			)
		or
                (
                    child_cmtc_nrc_screening_detail.referred_to in (select id from assigned_health_infrastructures)
                    and child_cmtc_nrc_screening_detail.state=''REFERRED''
                )
	)
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
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
case when to_hid.id in (select id from assigned_health_infrastructures) and child_cmtc_nrc_screening_detail.state=''REFERRED'' then ''referredToPending''
	when to_hid.id in (select id from assigned_health_infrastructures) and child_cmtc_nrc_screening_detail.state!=''REFERRED'' then ''referredToComplete''
	when from_hid.id in (select id from assigned_health_infrastructures) then ''referredFrom'' end as "referredType",
from_hid.name as "referredFromScreeningCenter",
to_hid.name as "referredToScreeningCenter",
child_cmtc_nrc_screening_detail.referred_date as "referredDate",
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
asha_detail.asha as "ashaDetails",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
inner join health_infrastructure_details from_hid on child_cmtc_nrc_screening_detail.referred_from = from_hid.id
inner join health_infrastructure_details to_hid on child_cmtc_nrc_screening_detail.referred_to = to_hid.id
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_treatment_completed_list';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'fe185fb9-2a1d-40fc-8cd1-357278e02a8f', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_treatment_completed_list',
'offset,limit,userId',
'with child_ids as (
	select child_cmtc_nrc_screening_detail.id,
	child_cmtc_nrc_screening_detail.child_id
	from child_cmtc_nrc_screening_detail
	inner join user_health_infrastructure on child_cmtc_nrc_screening_detail.screening_center = user_health_infrastructure.health_infrastrucutre_id
	and user_health_infrastructure.state = ''ACTIVE''
	inner join health_infrastructure_details on user_health_infrastructure.health_infrastrucutre_id = health_infrastructure_details.id
	and (health_infrastructure_details.is_cmtc or health_infrastructure_details.is_nrc or health_infrastructure_details.is_sncu)
	where user_health_infrastructure.user_id = #userId#
	and child_cmtc_nrc_screening_detail.state = ''DISCHARGE''
	and child_cmtc_nrc_screening_detail.is_case_completed
	limit #limit# offset #offset#
),asha_detail as (
	select child_ids.id,
	string_agg(concat(asha.first_name,'' '',asha.middle_name,'' '',asha.last_name,'' ('',asha.contact_number,'')''),'','') as asha
	from child_ids
	inner join imt_member on child_ids.child_id = imt_member.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	inner join um_user_location asha_location on imt_family.area_id = asha_location.loc_id and asha_location.state = ''ACTIVE''
	inner join um_user asha on asha_location.user_id = asha.id and asha.state = ''ACTIVE'' and asha.role_id = 24
	group by child_ids.id
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
asha_detail.asha as "ashaDetails",
location.name as "villageName",
area.name as "areaName"
from child_ids
inner join child_cmtc_nrc_screening_detail on child_ids.id = child_cmtc_nrc_screening_detail.id
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

delete from QUERY_MASTER where CODE='child_cmtc_nrc_screening_details';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'ad0b794e-372d-4371-b7b1-d02d0919a7a8', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_screening_details',
'childId',
'with child_detail as (
	select child_cmtc_nrc_screening_detail.id as "screeningId",
	child_cmtc_nrc_screening_detail.child_id as "childId",
	child_cmtc_nrc_screening_detail.screened_on as "screenedOn",
	child_cmtc_nrc_screening_detail.location_id as "locationId",
	child_cmtc_nrc_screening_detail.location_hierarchy_id as "locationHierarchyId",
	child_cmtc_nrc_screening_detail.state,
	child_cmtc_nrc_screening_detail.appetite_test_done as "appetiteTestDone",
	child_cmtc_nrc_screening_detail.appetite_test_reported_on as "appetiteTestReportedOn",
	child_cmtc_nrc_screening_detail.admission_id as "admissionId",
	child_cmtc_nrc_screening_detail.discharge_id as "dischargeId",
	child_cmtc_nrc_screening_detail.is_direct_admission as "isDirectAdmission",
	child_cmtc_nrc_screening_detail.screening_center as "screeningCenter",
	child_cmtc_nrc_screening_detail.is_case_completed as "isCaseCompleted",
	child_cmtc_nrc_screening_detail.referred_from as "referredFrom",
	child_cmtc_nrc_screening_detail.referred_to as "referredTo",
	child_cmtc_nrc_screening_detail.referred_date as "referredDate",
	child_cmtc_nrc_screening_detail.is_archive as "isArchive",
	child_cmtc_nrc_screening_detail.created_by as "createdBy",
	health_infrastructure_details.name as "healthInfrastructureName",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.family_id as "familyId",
	caste.value as "caste",
	imt_family.bpl_flag as "bpl",
	imt_member.gender as "gender",
	imt_member.dob as "dob",
	imt_member.immunisation_given as "immunisationGiven",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "childName",
	concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
	mother.mobile_number as "mobileNumber",
	get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
	concat(creator.first_name,'' '',creator.middle_name,'' '',creator.last_name) as "referredBy"
	from child_cmtc_nrc_screening_detail
	inner join imt_member on child_cmtc_nrc_screening_detail.child_id = imt_member.id
	left join imt_member mother on imt_member.mother_id = mother.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	left join um_user creator on child_cmtc_nrc_screening_detail.created_by = creator.id
	left join health_infrastructure_details on child_cmtc_nrc_screening_detail.screening_center = health_infrastructure_details.id
	left join listvalue_field_value_detail caste on imt_family.caste = cast(caste.id as character varying)
	where child_cmtc_nrc_screening_detail.child_id = #childId#
	and child_cmtc_nrc_screening_detail.is_case_completed is null
),asha_detail as (
	select child_detail."screeningId",
	string_agg(concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name,'' ('',um_user.contact_number,'')''),'','') as asha
	from child_detail
	left join um_user_location on child_detail."locationId" = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	left join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	where um_user.role_id = 24
	group by child_detail."screeningId"
)select child_detail.*,asha_detail.asha as "ashaDetails"
from child_detail
left join asha_detail on child_detail."screeningId" = asha_detail."screeningId"',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='child_cmtc_nrc_screening_details_for_direct_admission';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'4ba9d57f-faa8-4b5c-9e30-24cfd488bc45', 60512,  current_date , 60512,  current_date , 'child_cmtc_nrc_screening_details_for_direct_admission',
'childId',
'with member_detail as (
	select imt_member.id as "childId",
	imt_member.unique_health_id as "uniqueHealthId",
	imt_member.family_id as "familyId",
	caste.value as "caste",
	imt_family.bpl_flag as "bpl",
	imt_member.gender as "gender",
	imt_member.dob as "dob",
	concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "childName",
	concat(mother.first_name,'' '',mother.middle_name,'' '',mother.last_name) as "motherName",
	mother.mobile_number as "mobileNumber",
	get_location_hierarchy(case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end) as "locationHierarchy",
	case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end as "locationId"
	from imt_member
	left join imt_member mother on imt_member.mother_id = mother.id
	inner join imt_family on imt_member.family_id = imt_family.family_id
	left join listvalue_field_value_detail caste on imt_family.caste = cast(caste.id as character varying)
	where imt_member.id = #childId#
),asha_detail as (
	select member_detail."childId",
	string_agg(concat(um_user.first_name,'' '',um_user.middle_name,'' '',um_user.last_name,'' ('',um_user.contact_number,'')''),'','') as asha
	from member_detail
	left join um_user_location on member_detail."locationId" = um_user_location.loc_id
	and um_user_location.state = ''ACTIVE''
	left join um_user on um_user_location.user_id = um_user.id
	and um_user.state = ''ACTIVE''
	where um_user.role_id = 24
	group by member_detail."childId"
)select member_detail.*,asha_detail.asha as "ashaDetails"
from member_detail
left join asha_detail on member_detail."childId" = asha_detail."childId"',
null,
true, 'ACTIVE');