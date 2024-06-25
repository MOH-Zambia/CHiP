DELETE FROM QUERY_MASTER WHERE CODE='fetch_soh_element_timeline_intervals';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'75edc26c-8a1d-4117-924a-d26072c2d1fc', -1,  current_date , -1,  current_date , 'fetch_soh_element_timeline_intervals',
 null,
'select
	label as "displayValue",
	timeline_type as "value",
	is_default as "checked",
       from_date,
       to_date
from
	soh_element_timeline_intervals
where
	is_active = true;',
null,
true, 'ACTIVE');