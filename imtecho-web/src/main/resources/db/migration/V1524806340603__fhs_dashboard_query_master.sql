INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state)
    VALUES (1027,localtimestamp,null,null,'fhs_dashboard_locationwise_data','locationId,userId',
    'select cast(loc.id as varchar) as id, loc.name as value, loc.type as "locationType" 
                 ,cast(coalesce(sum(fhs_imported_from_emamta_family), 0) as int) as "importedFromEmamta" 
                 ,cast(coalesce(sum(fhs_imported_from_emamta_member), 0) as int) as "importedFromEmamtaMember" 
                 ,cast(coalesce(sum(fhs_to_be_processed_family), 0) as int) as "unverifiedFHS" 
                 ,cast(coalesce(sum(fhs_verified_family), 0) as int) as "verifiedFHS" 
                 ,cast(coalesce(sum(fhs_archived_family), 0) as int) as "archivedFHS" 
                 ,cast(coalesce(sum(fhs_new_family), 0) as int) as "ewFamily" 
                 ,cast(coalesce(sum(fhs_total_member), 0) as int) as "totalMember" 
                 ,cast(coalesce(sum(fhs_inreverification_family), 0) as int) as "inReverification" 
                 ,cast(coalesce(worker_det.worker_cnt, 0) as int) as worker 
                 from um_user_location um_loc 
                 inner join location_hierchy_closer_det um_loc_closer 
                 on um_loc.loc_id = um_loc_closer.parent_id and um_loc.state = ''ACTIVE'' and user_id = #userId#
                 inner join location_hierchy_closer_det sel_loc_closer 
                 on sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and depth = 1)
                 and sel_loc_closer.child_id = um_loc_closer.child_id
                 inner join location_wise_analytics loc_anlyts
                 on loc_anlyts.loc_id = sel_loc_closer.child_id
                 inner join location_master loc on loc.id = sel_loc_closer.parent_id
                 left join (select parent_id,count(*) as worker_cnt from (select Distinct sel_loc_closer.parent_id,user_loc.user_id
                 from um_user_location um_loc 
                 inner join location_hierchy_closer_det um_loc_closer 
                 on um_loc.loc_id = um_loc_closer.parent_id and um_loc.state = ''ACTIVE'' and user_id = #userId#
                 inner join location_hierchy_closer_det sel_loc_closer 
                 on sel_loc_closer.parent_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId# and depth = 1)
                 and sel_loc_closer.child_id = um_loc_closer.child_id
                 inner join um_user_location user_loc
                 on user_loc.loc_id = sel_loc_closer.child_id and user_loc.state = ''ACTIVE''
                 inner join um_user on um_user.id = user_loc.user_id 
                 and um_user.role_id = (select id from um_role_master where name = ''FHW'') and um_user.state = ''ACTIVE'') as temp group by parent_id
                 ) as worker_det on worker_det.parent_id = sel_loc_closer.parent_id
                 group by loc.id,worker_det.worker_cnt order by value;',true,'ACTIVE');


INSERT INTO public.query_master(created_by, created_on, modified_by, modified_on, code, params,query, returns_result_set, state)
VALUES (1027,localtimestamp,null,null,'fhs_dashboard_star_performer',null,'select modified_by as "userId", count(*) as "recordUpdated" from imt_family 
where modified_by is not null and modified_on between current_date - 1 and current_date 
group by modified_by order by "recordUpdated"  limit 1;',true,'ACTIVE');


INSERT INTO query_master(created_by, created_on, modified_by, modified_on, code, params, query, returns_result_set, state)
    VALUES (1027,localtimestamp,null,null,'fhs_dashboard_userwise_list','userId,locationId',
    'select cast(user_loc.user_id as varchar) as id
                 ,um_user.first_name || '' '' || um_user.last_name || '' ('' || um_user.user_name || '' )'' as "personName"
                 ,cast(coalesce(sum(fhs_imported_from_emamta_family), 0) as int) as "importedFromEmamta" 
                 ,cast(coalesce(sum(fhs_imported_from_emamta_member), 0) as int) as "importedFromEmamtaMember" 
                 ,cast(coalesce(sum(fhs_to_be_processed_family), 0) as int) as "unverifiedFHS" 
                 ,cast(coalesce(sum(fhs_verified_family), 0) as int) as "verifiedFHS" 
                 ,cast(coalesce(sum(fhs_archived_family), 0) as int) as "archivedFHS" 
                 ,cast(coalesce(sum(fhs_new_family), 0) as int) as "newFamily" 
                 ,cast(coalesce(sum(fhs_verified_family + fhs_new_family), 0) as int) as "totalFamily" 
                 ,cast(coalesce(sum(fhs_total_member), 0) as int) as "totalMember" 
                 ,cast(coalesce(sum(fhs_inreverification_family), 0) as int) as "inReverification" 
                 from um_user_location um_loc 
                 inner join location_hierchy_closer_det um_loc_closer 
                 on um_loc.loc_id = um_loc_closer.parent_id and um_loc.state = ''ACTIVE'' and user_id = #userId#
                 inner join location_hierchy_closer_det sel_loc_closer 
                 on sel_loc_closer.parent_id = #locationId#
                 and sel_loc_closer.child_id = um_loc_closer.child_id
                 inner join um_user_location user_loc
                 on user_loc.loc_id = sel_loc_closer.child_id and user_loc.state = ''ACTIVE''
                 inner join um_user on um_user.id = user_loc.user_id 
                 and um_user.role_id = (select id from um_role_master where name = ''FHW'') and um_user.state = ''ACTIVE''
                 inner join location_wise_analytics loc_anlyts
                 on loc_anlyts.loc_id = um_loc_closer.child_id
                 group by user_loc.user_id, um_user.first_name, um_user.last_name, um_user.user_name 
                 order by "personName"',true,'ACTIVE');
