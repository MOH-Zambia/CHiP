DELETE FROM QUERY_MASTER WHERE CODE='get_data_quality_by_time_line_1';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'07e70988-12b1-4d2d-ac02-ad9430ca80ed', 74909,  current_date , 74909,  current_date , 'get_data_quality_by_time_line_1',
'locationId,elementName',
'select * from soh_timeline_analytics_temp where location_id =#locationId# and element_name in (#elementName#) and timeline_type=''YEAR_04_2019''',
null,
true, 'ACTIVE');