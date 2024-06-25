DELETE FROM QUERY_MASTER WHERE CODE='retrieve_rch_pnc_child_master_info';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'2c4e56e2-3528-4e30-a4b7-6679233cfc21', 75398,  current_date , 75398,  current_date , 'retrieve_rch_pnc_child_master_info',
'healthid',
'with pncchild as (
select
	*
from
	rch_pnc_child_master
where
	child_id = (
	select
		id
	from
		imt_member
	where
		unique_health_id = #healthid#
	limit 1)
order by
	created_on desc
limit 5 )
,dangersign as (
select
	danger.child_pnc_id,
	string_agg(list.value, '', '') as dangersigndata
from
pncchild
inner join
	rch_pnc_child_danger_signs_rel danger on danger.child_pnc_id = pncchild.id
inner join listvalue_field_value_detail list on
	danger.child_danger_signs = list.id
group by
	danger.child_pnc_id) ,
deathsign as (
select
	death.child_pnc_id,
	string_agg(list.value, '', '') as deathsigndata
from
	rch_pnc_child_death_reason_rel death
left join listvalue_field_value_detail list on
	death.child_death_reason = list.id
group by
	death.child_pnc_id) select
	pncchild.id as "pncChildId",
	pncchild.pnc_master_id as "pncMasterId",
	pncchild.child_id as "childId",
	pncchild.is_alive as "isAlive",
	pncchild.other_danger_sign as "childOtherDanger",
	pncchild.child_weight as "childWeight",
	pncchild.created_by as "createdBy",
	pncchild.created_on as "createdOn",
	pncchild.modified_by as "modifiedBy",
	pncchild.modified_on as "modifiedOn",
	pncchild.member_status as "memberStatus",
	pncchild.death_date as "childDeathDate",
	pncchild.death_reason as "childDeathReason",
	pncchild.place_of_death as "childDeathPlace",
	pncchild.referral_place as "childReferralPlace",
	pncchild.other_death_reason as "childDeathOtherReason",
	pncchild.is_high_risk_case as "isHighRiskCase",
	pncchild.child_referral_done as "childReferralDone",
	pncmaster.family_id,
	pncmaster.latitude,
	pncmaster.longitude,
	pncmaster.mobile_start_date as "mobileStartDate",
	pncmaster.mobile_end_date as "mobileEndDate",
	pncmaster.location_id as "locationId",
	pncmaster.location_hierarchy_id as "locationHierarchyId",
	pncmaster.notification_id as "notificationId",
	pncmaster.pregnancy_reg_det_id as "pregnancyRegDetId",
	pncmaster.pnc_no as "pncNo",
	pncmaster.is_from_web as "isFromWeb",
	pncmaster.service_date as "serviceDate",
	usr.first_name || '' '' || usr.middle_name || '' '' || usr.last_name as usrfullname,
	usr.user_name as username,
	referralplace.value as referralplacename,
	fam.family_id as familyid,
	loc.name as locationname,
	danger.dangersigndata,
	death.deathsigndata
from
	pncchild
left join rch_pnc_master pncmaster on
	pncchild.pnc_master_id = pncmaster.id
left join imt_family fam on
	pncmaster.family_id = fam.id
left join location_master loc on
	pncmaster.location_id = loc.id
left join um_user usr on
	pncchild.created_by = usr.id
left join deathsign death on
	pncchild.id = death.child_pnc_id
left join dangersign danger on
	pncchild.id = danger.child_pnc_id
left join listvalue_field_value_detail referralplace on
	pncchild.referral_place = referralplace.id
order by
	pncmaster.service_date desc
limit 5',
'Retrieve RCH PNC Child Master Information',
true, 'ACTIVE');