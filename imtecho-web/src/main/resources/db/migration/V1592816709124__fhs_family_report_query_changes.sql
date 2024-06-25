delete from QUERY_MASTER where CODE='fhs_report_family_search';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'006f60bc-026b-48cf-84b1-0afafe3d2c5d', 60512,  current_date , 60512,  current_date , 'fhs_report_family_search',
'is_less_then_five_req,offset,is_pregnant_req,limit,location_id',
'with loc_det as (select
	case when type in(''AA'',''A'') then #location_id# else null end as area_id,
	case when type in(''AA'',''A'') then parent else #location_id# end as location_id
	from location_master where id = #location_id#)
select fam_id.family_id
--,contact.first_name || '' '' ||contact.last_name as contact_person
,string_agg(imt_member.first_name || '' '' || imt_member.last_name,'' , '') as member_name
,max(case when imt_member.family_head = true then imt_member.first_name || '' '' || imt_member.last_name else null end) contact_person
from (
select Distinct imt_family.family_id from imt_family,imt_member,location_hierchy_closer_det,loc_det
where imt_family.family_id = imt_member.family_id  and location_hierchy_closer_det.parent_id = loc_det.location_id
and imt_family.state in (
''com.argusoft.imtecho.family.state.verified'',''com.argusoft.imtecho.family.state.fhw.reverified'',''com.argusoft.imtecho.family.state.emri.fhw.reverified'',''com.argusoft.imtecho.family.state.emri.verified.ok'',
''com.argusoft.imtecho.family.state.emri.fhw.reverified.dead'',''com.argusoft.imtecho.family.state.emri.fhw.reverified.verified'',''com.argusoft.imtecho.family.state.emri.verified.ok.dead'',
''com.argusoft.imtecho.family.state.emri.verification.pool.dead'',''com.argusoft.imtecho.family.state.emri.verification.pool.verified'',''com.argusoft.imtecho.family.state.emri.verification.pool.archived'',
''com.argusoft.imtecho.family.state.emri.verification.pool'',''com.argusoft.imtecho.family.state.emri.verified.ok.verified'',''com.argusoft.imtecho.family.state.mo.fhw.reverified'',
''com.argusoft.imtecho.family.state.emri.fhw.reverified.archived'',''com.argusoft.imtecho.family.state.emri.verified.ok.archived'',''com.argusoft.imtecho.family.state.new'',
''com.argusoft.imtecho.family.state.new.fhsr.verified'',''com.argusoft.imtecho.family.state.new.fhw.reverified'',''com.argusoft.imtecho.family.state.new.mo.verified'',
''com.argusoft.imtecho.family.state.new.mo.fhw.reverified'',
''CFHC_FU'',''CFHC_FV'',''CFHC_FN'',''CFHC_FIR'',''CFHC_GVK_FIR'',''CFHC_GVK_FV'',
''CFHC_MO_FV'',''CFHC_GVK_FRV'',''CFHC_MO_FRV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'')
and (
	(case when #is_pregnant_req# = true and #is_less_then_five_req# = true then (is_pregnant is true or dob > now() - interval ''5 years'') else true end)
	or (case when #is_pregnant_req# = true then is_pregnant is true else true end)
	or (case when #is_less_then_five_req# = true then dob > now() - interval ''5 years'' else true end)
)
and location_hierchy_closer_det.child_id = imt_family.location_id
and (loc_det.area_id is null or loc_det.area_id = imt_family.area_id)
and imt_member.basic_state in (''NEW'',''VERIFIED'')
order by imt_family.family_id
limit #limit# offset #offset#) as fam_id
inner join imt_member on fam_id.family_id = imt_member.family_id
--left join imt_member as contact on fam_id.hof_id = contact.id
where imt_member.basic_state in (''NEW'',''VERIFIED'')
group by fam_id.family_id',
'retrieve family report from location',
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='family_report_detail';

insert into QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
values (
'9e201501-45f2-4861-bb1b-376d4ad4afb8', 60512,  current_date , 60512,  current_date , 'family_report_detail',
'is_less_then_five_req,is_pregnant_req,family_ids,location_id',
'with family_id_list as (
select family_id from imt_family where family_id in (#family_ids#) limit 300
),loc_det as (select
	cast (case when type in(''AA'',''A'') then #location_id# else null end as integer) as area_id ,
	case when type in(''AA'',''A'') then parent else #location_id# end as location_id
	from location_master where id = #location_id# and (select count(1) from family_id_list) = 0
),family_detail as (
select Distinct imt_family.family_id
from imt_family,imt_member,location_hierchy_closer_det,loc_det
where imt_family.family_id = imt_member.family_id  and location_hierchy_closer_det.parent_id = loc_det.location_id
and imt_family.state in (
''com.argusoft.imtecho.family.state.verified'',''com.argusoft.imtecho.family.state.fhw.reverified'',''com.argusoft.imtecho.family.state.emri.fhw.reverified'',''com.argusoft.imtecho.family.state.emri.verified.ok'',
''com.argusoft.imtecho.family.state.emri.fhw.reverified.dead'',''com.argusoft.imtecho.family.state.emri.fhw.reverified.verified'',''com.argusoft.imtecho.family.state.emri.verified.ok.dead'',
''com.argusoft.imtecho.family.state.emri.verification.pool.dead'',''com.argusoft.imtecho.family.state.emri.verification.pool.verified'',''com.argusoft.imtecho.family.state.emri.verification.pool.archived'',
''com.argusoft.imtecho.family.state.emri.verification.pool'',''com.argusoft.imtecho.family.state.emri.verified.ok.verified'',''com.argusoft.imtecho.family.state.mo.fhw.reverified'',
''com.argusoft.imtecho.family.state.emri.fhw.reverified.archived'',''com.argusoft.imtecho.family.state.emri.verified.ok.archived'',''com.argusoft.imtecho.family.state.new'',
''com.argusoft.imtecho.family.state.new.fhsr.verified'',''com.argusoft.imtecho.family.state.new.fhw.reverified'',''com.argusoft.imtecho.family.state.new.mo.verified'',
''com.argusoft.imtecho.family.state.new.mo.fhw.reverified'',
''CFHC_FU'',''CFHC_FV'',''CFHC_FN'',''CFHC_FIR'',''CFHC_GVK_FIR'',''CFHC_GVK_FV'',
''CFHC_MO_FV'',''CFHC_GVK_FRV'',''CFHC_MO_FRV'',''CFHC_GVK_FRVP'',''CFHC_MO_FRVP'')
and (
	(case when #is_pregnant_req# = true and #is_less_then_five_req# = true then (is_pregnant is true or dob > now() - interval ''5 years'') else true end)
	or (case when #is_pregnant_req# = true then is_pregnant is true else true end)
	or (case when #is_less_then_five_req# = true then dob > now() - interval ''5 years'' else true end)
)
and location_hierchy_closer_det.child_id = imt_family.location_id
and (loc_det.area_id is null or loc_det.area_id = imt_family.area_id)
and imt_member.basic_state in (''NEW'',''VERIFIED'') and (select count(1) from family_id_list) = 0
union all
select family_id from family_id_list
)
select fam.family_id,member_detail
,contact.first_name || '' '' || contact.last_name as hof,
religious.value as religion,
bpl_flag,
rsby_card_number,
migratory_flag,
toilet_available_flag,
cast_det.value as caste,
maa_vatsalya_number,
address1||'' , <br/>''|| address2 as address,
house_number,
cast(json_agg(
json_build_object(
''location_type'',location_type_master.name
,''location_name'',location_master.name
)ORDER BY level) as text) as loc_details
from(
select imt_family.family_id,religion,bpl_flag,rsby_card_number,migratory_flag,toilet_available_flag,contact_person_id,caste,location_id,maa_vatsalya_number,address1,address2,house_number,
cast (json_agg(
json_build_object(
''id'',imt_member.id
,''name'',imt_member.name
,''unique_health_id'',imt_member.unique_health_id
,''year'',imt_member.year1
,''month'',imt_member.month1
,''day'',imt_member.day1
,''gender'',imt_member.gender
,''marital_status'',imt_member.marital_status
,''is_pregnant'',imt_member.is_pregnant
,''family_planning_method'',imt_member.family_planning_method
,''dob'',imt_member.education_status
,''mobile_number'',imt_member.mobile_number
,''account_number'',imt_member.account_number
,''ifsc'',imt_member.ifsc
,''eye_issue_detail'',imt_member.eye_issue_ids
,''chronic_disease_detail'',imt_member.chronic_disease_ids
,''current_disease_detail'',imt_member.current_disease_ids
)) as text) as member_detail
from imt_family
left join (
select id,family_id,first_name || '' '' || middle_name || '' '' || last_name as name
,unique_health_id
,extract(year from age(dob)) as year1
,extract(month from age(dob)) as month1
,extract(day from age(dob)) as day1
,gender
,marital_status
,is_pregnant
,family_planning_method
,education_status
,mobile_number
,account_number
,ifsc
	,eye_issue_ids
	,chronic_disease_ids
	,current_disease_ids
	from imt_member
	left join (
	select member_id as id,string_agg(listvalue_field_value_detail.value,'','')as eye_issue_ids
	from imt_member_eye_issue_rel
	inner join listvalue_field_value_detail on imt_member_eye_issue_rel.eye_issue_id = listvalue_field_value_detail.id
	group by member_id
	) imt_member_eye_issue_rel using (id)
        left join (
	select member_id as id,string_agg(listvalue_field_value_detail.value,'','')as chronic_disease_ids
	from imt_member_chronic_disease_rel
	inner join listvalue_field_value_detail on imt_member_chronic_disease_rel.chronic_disease_id = listvalue_field_value_detail.id
	group by member_id
	) imt_member_chronic_disease_rel using (id)
	left join (
	select member_id as id,string_agg(listvalue_field_value_detail.value,'','')as current_disease_ids
	from imt_member_current_disease_rel
	inner join listvalue_field_value_detail on imt_member_current_disease_rel.current_disease_id = listvalue_field_value_detail.id
	group by member_id
	) imt_member_current_disease_rel using (id)
	where state in (''com.argusoft.imtecho.member.state.verified''
,''com.argusoft.imtecho.member.state.mo.fhw.reverified'',''com.argusoft.imtecho.member.state.fhw.reverified'',''com.argusoft.imtecho.member.state.new'',
''com.argusoft.imtecho.member.state.new.fhw.reverified'',
''CFHC_MU'',''CFHC_MV'',''CFHC_MN'',''CFHC_MIR'',''CFHC_MMOV'',''CFHC_MD'')

) imt_member USING (family_id)
/*left join family_detail on imt_family.family_id = family_detail.family_id*/
where imt_family.family_id in (select family_id from family_detail)

group by imt_family.family_id,religion,bpl_flag,rsby_card_number,migratory_flag,toilet_available_flag,contact_person_id,caste,location_id
,maa_vatsalya_number,address1,address2,house_number) as fam
left join imt_member contact on fam.contact_person_id = contact.id
left join listvalue_field_value_detail cast_det on cast (fam.caste as integer) = cast_det.id
left join listvalue_field_value_detail religious on cast (fam.religion as integer) = religious.id
inner join location_hierchy_closer_det on fam.location_id = location_hierchy_closer_det.child_id
inner join location_master on location_hierchy_closer_det.parent_id = location_master.id
inner join location_type_master on location_master.type = location_type_master.type
group by fam.family_id,member_detail,contact.first_name || '' '' || contact.last_name,religious.value,bpl_flag,
rsby_card_number,
migratory_flag,
toilet_available_flag,
cast_det.value,
maa_vatsalya_number,
address1||'' , <br/>''|| address2,
house_number;',
'retrieve family wise report for print',
true, 'ACTIVE');