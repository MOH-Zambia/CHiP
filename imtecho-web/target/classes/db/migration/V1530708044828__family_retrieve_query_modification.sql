update query_master 
set query = 'select imt_family.family_id,contact.first_name || '' '' ||contact.last_name as contact_person,string_agg(imt_member.first_name || '' '' || imt_member.last_name,'' , '') as member_name from (
select Distinct imt_family.family_id from imt_family,imt_member,location_hierchy_closer_det
where imt_family.family_id = imt_member.family_id  and location_hierchy_closer_det.parent_id = #location_id# 
and imt_family.state in (''com.argusoft.imtecho.family.state.new''
,''com.argusoft.imtecho.family.state.new.fhsr.verified''
,''com.argusoft.imtecho.family.state.verified''
,''com.argusoft.imtecho.family.state.fhw.reverified'')
and (((''#is_pregnant_req#'' =true and is_pregnant = true) 
or (''#is_less_then_five_req#'' = true and (dob > now() - INTERVAL ''5 years'')))
or (''#is_less_then_five_req#'' = false and ''#is_pregnant_req#'' = false))
and location_hierchy_closer_det.child_id = imt_family.location_id
order by imt_family.family_id
limit #limit# offset #offset#) as fam_id 
inner join imt_family on fam_id.family_id = imt_family.family_id 
inner join imt_member on imt_family.family_id = imt_member.family_id
left join imt_member as contact on imt_family.contact_person_id = contact.id
group by imt_family.family_id,contact.first_name || '' '' ||contact.last_name;'
where code = 'fhs_report_family_search';