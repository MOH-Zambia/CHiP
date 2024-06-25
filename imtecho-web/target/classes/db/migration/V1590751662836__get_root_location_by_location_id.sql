DELETE FROM QUERY_MASTER WHERE CODE='get_root_location_by_location_id';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'65aa297d-aad5-4e32-abd6-f71bb9ae6aff', 74909,  current_date , 74909,  current_date , 'get_root_location_by_location_id',
'location_id',
'select
	l2.name,
	l2.id
from
	location_master l1
inner join location_hierchy_closer_det lhcd on
	lhcd.child_id = l1.id
inner join location_master l2 on
	l2.id = lhcd.parent_id
where
	l1.id = #location_id#
order by
	lhcd.depth desc
limit 1',
null,
true, 'ACTIVE');