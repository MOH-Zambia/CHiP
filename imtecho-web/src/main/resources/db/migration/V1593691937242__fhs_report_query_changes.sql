delete from QUERY_MASTER where CODE='fhs_report_family_search';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'006f60bc-026b-48cf-84b1-0afafe3d2c5d', 60512,  current_date , 60512,  current_date , 'fhs_report_family_search',
'is_less_then_five_req,offset,is_pregnant_req,limit,location_id',
'with family_ids as (
	select imt_family.family_id
	from imt_family
	inner join location_hierchy_closer_det on imt_family.area_id = location_hierchy_closer_det.child_id
	inner join imt_member on imt_family.family_id = imt_member.family_id
		and imt_member.basic_state in (''NEW'',''VERIFIED'')
	where location_hierchy_closer_det.parent_id = #location_id#
	and imt_family.basic_state in (''NEW'',''VERIFIED'')
	group by imt_family.family_id
	having case when #is_pregnant_req# = true and #is_less_then_five_req# = true then count(1) filter (where imt_member.is_pregnant) > 0 and count(1) filter (where imt_member.dob > now() - interval ''5 years'') > 0
				when #is_pregnant_req# = true then count(1) filter (where imt_member.is_pregnant) > 0
				when #is_less_then_five_req# = true then count(1) filter (where imt_member.dob > now() - interval ''5 years'') > 0
			else true end
	limit #limit# offset #offset#
),family_head_details as (
	select family_ids.family_id,
	imt_member.id,
	concat(imt_member.first_name,'' '',imt_member.last_name) as member_name
	from family_ids
	inner join imt_member on family_ids.family_id = imt_member.family_id
	and imt_member.family_head
),details as (
	select family_ids.family_id,
	string_agg(concat(imt_member.first_name,'' '',imt_member.last_name),'','') as member_name
	from family_ids
	inner join imt_member on family_ids.family_id = imt_member.family_id
	group by family_ids.family_id
)
select details.family_id,
details.member_name,
family_head_details.member_name as contact_person
from details
left join family_head_details on details.family_id = family_head_details.family_id',
'retrieve family report from location',
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='family_report_detail';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'9e201501-45f2-4861-bb1b-376d4ad4afb8', 60512,  current_date , 60512,  current_date , 'family_report_detail',
'family_ids',
'with family_details as (
	select imt_family.family_id,
	imt_family.location_id,
	concat(hof.first_name,'' '',hof.last_name) as hof,
	religion.value as religion,
	caste.value as caste,
	imt_family.bpl_flag,
	imt_family.rsby_card_number,
	imt_family.migratory_flag,
	imt_family.toilet_available_flag,
	imt_family.maa_vatsalya_number,
	concat(imt_family.address1,''<br/>'',imt_family.address2) as address,
	imt_family.house_number
	from imt_family
	left join imt_member hof on imt_family.family_id = hof.family_id and hof.family_head
	left join listvalue_field_value_detail religion on cast(imt_family.religion as integer) = religion.id
	left join listvalue_field_value_detail caste on cast(imt_family.caste as integer) = caste.id
	where imt_family.family_id in (#family_ids#)
),location_details as (
	select family_details.family_id,
	cast(
		json_agg(
			json_build_object(
				''location_type'',location_type_master.name,
				''location_name'',location_master.name
			) order by level
		) as text
	) as loc_details
	from family_details
	inner join location_hierchy_closer_det on family_details.location_id = location_hierchy_closer_det.child_id
	inner join location_master on location_hierchy_closer_det.parent_id = location_master.id
	inner join location_type_master on location_master.type = location_type_master.type
	group by family_details.family_id
),member_details as (
	select family_details.family_id,
	cast(
		json_agg(
			json_build_object(
				''id'',imt_member.id,
				''name'',concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name),
				''unique_health_id'',imt_member.unique_health_id,
				''year'',extract(year from age(imt_member.dob)),
				''month'',extract(month from age(imt_member.dob)),
				''day'',extract(day from age(imt_member.dob)),
				''gender'',imt_member.gender,
				''marital_status'',imt_member.marital_status,
				''is_pregnant'',imt_member.is_pregnant,
				''family_planning_method'',imt_member.family_planning_method,
				''education_status'',imt_member.education_status,
				''mobile_number'',imt_member.mobile_number,
				''account_number'',imt_member.account_number,
				''ifsc'',imt_member.ifsc,
				''eye_issue_detail'',(select string_agg(eye_issues.value,'','')
									from imt_member_eye_issue_rel
									inner join listvalue_field_value_detail eye_issues on imt_member_eye_issue_rel.eye_issue_id = eye_issues.id
									where imt_member_eye_issue_rel.member_id = imt_member.id),
				''chronic_disease_detail'',(select string_agg(eye_issues.value,'','')
									from imt_member_chronic_disease_rel
									inner join listvalue_field_value_detail eye_issues on imt_member_chronic_disease_rel.chronic_disease_id = eye_issues.id
									where imt_member_chronic_disease_rel.member_id = imt_member.id),
				''current_disease_detail'',(select string_agg(eye_issues.value,'','')
									from imt_member_current_disease_rel
									inner join listvalue_field_value_detail eye_issues on imt_member_current_disease_rel.current_disease_id = eye_issues.id
									where imt_member_current_disease_rel.member_id = imt_member.id)
			)
		) as text
	) as member_detail
	from family_details
	inner join imt_member on family_details.family_id = imt_member.family_id
	group by family_details.family_id
)
select family_details.*,
location_details.loc_details,
member_details.member_detail
from family_details
left join location_details on family_details.family_id = location_details.family_id
left join member_details on family_details.family_id = member_details.family_id',
'retrieve family wise report for print',
true, 'ACTIVE');