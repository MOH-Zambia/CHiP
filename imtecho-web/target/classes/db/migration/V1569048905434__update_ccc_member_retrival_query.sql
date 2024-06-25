update query_master 

set query = 'with mem_loc_id as(
 select * from um_user_location
 where user_id = #moId# and state = ''ACTIVE''
)
,mo_info as(
  select mo.id as mo_user_id, string_agg(get_location_hierarchy(us_loc.loc_id),'','') as mo_location,
  mo.first_name || '' '' || mo.middle_name || '' '' || mo.last_name as mo_name,
  mo.contact_number as mo_mobile_number,
  mo.email_id as mo_email_id
  from um_user_location us_loc
  inner join um_user mo on mo.id = us_loc.user_id
  where us_loc.state = ''ACTIVE''
  and mo.id = #moId#
  group by mo.id, mo.first_name,mo.middle_name,mo.last_name ,
  mo.contact_number,mo.email_id
  )
,location_list as(
 select child_id as child_loc_id
 from location_hierchy_closer_det,mem_loc_id
 where parent_id = mem_loc_id.loc_id
)
,anm_info as(
 select fhw.id as fhw_user_id,
 fhw.first_name || '' '' || fhw.middle_name || '' '' || fhw.last_name as fhw_name,
 fhw.contact_number as fhw_mobile_number,
 string_agg(loc.name,'', '') as village_name
 from um_user fhw
 inner join um_user_location us_loc on fhw.id = us_loc.user_id
 inner join location_master loc on loc.id = us_loc.loc_id
 cross join location_list
 where fhw.role_id in (30) and fhw.state = ''ACTIVE'' and us_loc.state = ''ACTIVE''
 and us_loc.loc_id =  location_list.child_loc_id
 group by fhw.id, fhw.first_name, fhw.middle_name, fhw.last_name
)
,fhw_mo_tho_info as(
 select * from anm_info, mo_info
)

(
select
fhw_mo_tho_info.mo_user_id,
fhw_mo_tho_info.mo_name,
fhw_mo_tho_info.mo_mobile_number,
fhw_mo_tho_info.fhw_name,
fhw_mo_tho_info.fhw_mobile_number,
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name,'' ('',imt_member.unique_health_id,'')'') as member_name_id,
get_location_hierarchy(mem.location_id) as location_hierarchy,
cast(mem.schedule_date as date) as due_date,
noti.name as service_type,
date_part(''day'',now()-mem.service_due_on_date) as since_days
from ccc_overdue_services_follow_up_info mem
inner join imt_member on imt_member.id = mem.member_id
inner join location_hierchy_closer_det lhcd on mem.location_id = lhcd.child_id and lhcd.parent_loc_type in (''V'',''ANG'')
inner join um_user_location us_loc on lhcd.parent_id = us_loc.loc_id and  us_loc.state = ''ACTIVE''
inner join um_user on us_loc.user_id = um_user.id and um_user.state = ''ACTIVE'' and um_user.role_id = 30
inner join notification_type_master noti on noti.id = mem.notification_type_id
cross join location_list
inner join fhw_mo_tho_info on fhw_mo_tho_info.fhw_user_id = um_user.id
left join gvk_high_risk_follow_up_usr_info high_risk on high_risk.member_id = mem.member_id and mem.notification_type_id = 2
where call_state in (''com.argusoft.imtecho.ccc.call.to-be-processed'', ''com.argusoft.imtecho.ccc.call.processing'')
and mem.call_attempt < 3
and mem.service_state in (''PENDING'' , ''RESCHEDULE'')
and location_list.child_loc_id = us_loc.loc_id
order by mem.id)

union all
(
select 
distinct mo_user_id, mo_name, mo_mobile_number, fhw_name, fhw_mobile_number, 
concat(mem.first_name,'' '',mem.middle_name,'' '',mem.last_name,'' ('', mem.unique_health_id,'')'') as member_name_id,
get_location_hierarchy(rch_mem.location_id) as location_hierarchy, cast(''01-01-1970'' as date) as due_date, ''Anemia'' as service_type, 0 as since_days
from rch_anc_master rch_mem
inner join imt_member mem on rch_mem.member_id = mem.id
inner join location_hierchy_closer_det lhcd on rch_mem.location_id = lhcd.child_id --and lhcd.parent_loc_type in (''V'',''ANG'')
inner join um_user_location us_loc on lhcd.parent_id = us_loc.loc_id and  us_loc.state = ''ACTIVE''
inner join um_user on us_loc.user_id = um_user.id and um_user.state = ''ACTIVE'' and um_user.role_id = 30
inner join fhw_mo_tho_info on fhw_mo_tho_info.fhw_user_id = um_user.id
where haemoglobin_count < 7
and rch_mem.location_id in ( select child_loc_id from location_list))'

where code = 'ccc_retrieve_query';