DELETE FROM QUERY_MASTER WHERE CODE='get_data_quality_by_time_line';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'f824cd38-0cfc-4a8b-8a3b-ee999f5336b1', -1,  current_date , -1,  current_date , 'get_data_quality_by_time_line',
'locationId,elementName',
'select * from soh_timeline_analytics_temp where location_id =#locationId# and element_name =''#elementName#'' and timeline_type=''YEAR_04_2019''',
null,
true, 'ACTIVE');