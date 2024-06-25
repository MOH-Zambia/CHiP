UPDATE public.query_master
   SET query='select loc_wise_summary.*,loc.name as value, loc.type as "locationType"
,coalesce(worker_det.worker_cnt, 0) as worker from (
select 
sel_loc_closer.parent_id as id,
coalesce(sum(fhs_imported_from_emamta_family),0) as "importedFromEmamta" 
,coalesce(sum(fhs_imported_from_emamta_member),0) as "importedFromEmamtaMember" 
,coalesce(sum(fhs_to_be_processed_family),0) as "unverifiedFHS" 
,coalesce(sum(fhs_verified_family),0) as "verifiedFHS" 
,coalesce(sum(fhs_archived_family),0) as "archivedFHS" 
,coalesce(sum(fhs_new_family),0)  as "ewFamily" 
,coalesce(sum(fhs_total_member),0) as "totalMember" 
,coalesce(sum(fhs_inreverification_family),0) as "inReverification" 
from  location_wise_analytics loc_anlyts inner join location_hierchy_closer_det sel_loc_closer--,location_master loc 
on loc_anlyts.loc_id = sel_loc_closer.child_id 
where sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and depth = 1)
group by sel_loc_closer.parent_id) loc_wise_summary 
inner join location_master loc 
on loc_wise_summary.id = loc.id
left join (select parent_id,count(*) as worker_cnt from (select Distinct sel_loc_closer.parent_id, um_user.id from  um_user,um_user_location user_loc,location_hierchy_closer_det sel_loc_closer
	where role_id = (select id from um_role_master where name = ''FHW'') and um_user.state = ''ACTIVE'' and um_user.id = user_loc.user_id and user_loc.state = ''ACTIVE'' and
	user_loc.loc_id = sel_loc_closer.child_id and sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and depth = 1)) as temp group by parent_id
) as worker_det on worker_det.parent_id = loc.id
order by value'
WHERE code='fhs_dashboard_locationwise_data';