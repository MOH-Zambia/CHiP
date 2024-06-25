DELETE FROM QUERY_MASTER WHERE CODE='fhs_report_family_search';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'006f60bc-026b-48cf-84b1-0afafe3d2c5d', 97070,  current_date , 97070,  current_date , 'fhs_report_family_search',
'is_less_then_five_req,offset,is_pregnant_req,limit,location_id',
'with family_ids as (
	select imt_family.family_id
	from imt_family
	inner join location_hierchy_closer_det on case when imt_family.area_id is not null then imt_family.area_id else imt_family.location_id end = location_hierchy_closer_det.child_id
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
    and imt_member.basic_state in (''NEW'',''VERIFIED'')
	group by family_ids.family_id
)
select details.family_id,
details.member_name,
family_head_details.member_name as contact_person
from details
left join family_head_details on details.family_id = family_head_details.family_id',
'retrieve family report from location',
true, 'ACTIVE');