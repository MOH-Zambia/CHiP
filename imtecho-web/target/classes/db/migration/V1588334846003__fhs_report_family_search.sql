DELETE FROM QUERY_MASTER WHERE CODE='fhs_report_family_search';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
1,  current_date , 1,  current_date , 'fhs_report_family_search',
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
and (((#is_pregnant_req# =true and is_pregnant = true)
or (#is_less_then_five_req# = true and (dob > now() - INTERVAL ''5 years'')))
or (#is_less_then_five_req# = false and #is_pregnant_req# = false))
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