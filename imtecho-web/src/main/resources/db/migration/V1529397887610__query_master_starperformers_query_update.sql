UPDATE public.query_master 
SET query = 'select first_name || '' '' || last_name || '' ('' || user_name || '')'' as person_name, record_submitted 
    from (select fam.modified_by as user_id, count(*) as "record_submitted"
    from location_hierchy_closer_det,imt_family as fam
    where location_hierchy_closer_det.parent_id 
    in (select loc_id from um_user_location where user_id = #userId# and state = ''ACTIVE'')
    and location_hierchy_closer_det.child_id = fam.location_id
    and fam.modified_by is not null and fam.modified_on between current_date - 1 and current_date
    group by fam.modified_by order by "record_submitted" desc limit 1) as star_perfomer_det,um_user
    where star_perfomer_det.user_id = um_user.id',
    params = 'userId'
WHERE code = 'fhs_dashboard_star_performer';