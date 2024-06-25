update query_master set query = 'select loc_wise_summary.*,loc.name as value, loc.type as "locationType",parent.parent_id as parent
,coalesce(worker_det.worker_cnt, 0) as worker,
case when loc_wise_summary."importedFromEmamta" = 0 then 0 else
round(((loc_wise_summary."verifiedFHS" + loc_wise_summary."archivedFHS" + loc_wise_summary."newFamily")*100)/loc_wise_summary."importedFromEmamta"\:\:numeric,2) end as percentage 
from (
select 
sel_loc_closer.parent_id as id,
coalesce(sum(fhs_imported_from_emamta_family),0) as "importedFromEmamta" 
,coalesce(sum(fhs_imported_from_emamta_member),0) as "importedFromEmamtaMember" 
,coalesce(sum(fhs_to_be_processed_family),0) as "unverifiedFHS" 
,coalesce(sum(fhs_verified_family),0) as "verifiedFHS" 
,coalesce(sum(fhs_archived_family),0) as "archivedFHS" 
,coalesce(sum(fhs_new_family),0)  as "newFamily" 
,coalesce(sum(fhs_total_member),0) as "totalMember" 
,coalesce(sum(fhs_inreverification_family),0) as "inReverification" 
from  location_wise_analytics loc_anlyts inner join location_hierchy_closer_det sel_loc_closer
on loc_anlyts.loc_id = sel_loc_closer.child_id 
where sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and (depth = 1 or depth = 2))
group by sel_loc_closer.parent_id) loc_wise_summary 
inner join location_master loc 
on loc_wise_summary.id = loc.id
left join (select parent_id,count(*) as worker_cnt from (select Distinct sel_loc_closer.parent_id, um_user.id from  um_user,um_user_location user_loc,location_hierchy_closer_det sel_loc_closer
	where role_id = (select id from um_role_master where name = ''FHW'') and um_user.state = ''ACTIVE'' and um_user.id = user_loc.user_id and user_loc.state = ''ACTIVE'' and
	user_loc.loc_id = sel_loc_closer.child_id and sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and (depth = 1 or depth = 2))) as temp group by parent_id
) as worker_det on worker_det.parent_id = loc.id
inner join location_hierchy_closer_det parent on parent.child_id = loc.id and parent.depth = 1
order by value'
where code = 'fhs_dashboard_locationwise_data';


update query_master set query = 'select to_char(vf.created_on,''dd-mm-yyyy'') as created_on,round((sum(vf.verified)*100)/sum(vf.total),1) as percentage from 
location_hierchy_closer_det lhcd inner join  verfied_families_village_wise_records vf
on lhcd.child_id = vf.loc_id
where 
((#locationId# is not null and parent_id = #locationId#) or
(#locationId# is null and parent_id in (select loc_id from um_user_location where user_id = #loggedInUserId# and state = ''ACTIVE'')))
and vf.created_on > current_date - interval ''10 days''
group by vf.created_on'
where code = 'fhs_verifification_percentage';