delete from query_master where code = 'fhs_report_family_search';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
    VALUES (1, localtimestamp, 'fhs_report_family_search', 'location_id,is_less_then_five_req,is_pregnant_req,limit,offset', 
        'select imt_family.family_id,contact.first_name || '' '' ||contact.last_name as contact_person,string_agg(imt_member.first_name || '' '' || imt_member.last_name,'' , '') as member_name from (
select Distinct imt_family.family_id from imt_family,imt_member,location_hierchy_closer_det
where location_hierchy_closer_det.parent_id = #location_id# and imt_family.family_id = imt_member.family_id  
and (((''#is_pregnant_req#'' =true and is_pregnant = true) 
or (''#is_less_then_five_req#'' = true and (dob > now() - INTERVAL ''5 years'')))
or (''#is_less_then_five_req#'' = false and ''#is_pregnant_req#'' = false))
and location_hierchy_closer_det.child_id = imt_family.location_id
order by imt_family.family_id
limit #limit# offset #offset#) as fam_id 
inner join imt_family on fam_id.family_id = imt_family.family_id 
inner join imt_member on imt_family.family_id = imt_member.family_id
left join imt_member as contact on imt_family.contact_person_id = contact.id
group by imt_family.family_id,contact.first_name || '' '' ||contact.last_name;', 
        true, 'ACTIVE', 'retrieve family report from location');

delete from query_master where code = 'family_report_detail';

INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
    VALUES (1, localtimestamp, 'family_report_detail', 'family_ids', 
        'select fam.family_id,member_detail
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

) imt_member USING (family_id) 

where imt_family.family_id in (#family_ids#)
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
        true, 'ACTIVE', 'retrieve family wise report for print');


INSERT INTO menu_config (menu_name, menu_type, active, navigation_state,feature_json) values 
('FHS Family Report','manage',TRUE,'techo.report.familyreport','{}');
