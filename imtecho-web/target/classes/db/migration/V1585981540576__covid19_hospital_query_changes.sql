delete from QUERY_MASTER where CODE='retrieve_covid_hospitals_by_location';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'retrieve_covid_hospitals_by_location',
'locationId',
'select *
from health_infrastructure_details
where (case when #locationId# is not null then location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) else true end)
and is_covid_hospital',
null,
true, 'ACTIVE');

delete from QUERY_MASTER where CODE='retrieve_covid_lab_test_by_location';

insert into public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'retrieve_covid_lab_test_by_location',
'locationId',
'select *
from health_infrastructure_details
where (case when #locationId# is not null then location_id in (select child_id from location_hierchy_closer_det where parent_id = #locationId#) else true end)
and is_covid_lab',
null,
true, 'ACTIVE');