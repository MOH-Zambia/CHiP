delete from query_master where code='fetch_all_lgd_code';
INSERT INTO public.QUERY_MASTER
( created_by, created_on, modified_by, modified_on,
		code, params, query, description, returns_result_set, state,uuid )
values (1,current_date,1,current_date,
	'fetch_all_lgd_code',
	'childid',
		'
	select
    child_id,
    count(*),
    string_agg(location_hierchy_closer_det.parent_loc_type || ''/'' || coalesce (location_master.lgd_code,''-1'')   ,'' , '' order by depth desc) as lgdCode
    from location_hierchy_closer_det, location_master
    where child_id = #childid#
    and location_master.id = location_hierchy_closer_det.parent_id
    group by child_id',
    'fetching all lgd code',true,'ACTIVE',uuid_generate_v4());