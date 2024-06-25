-- Query for testing status table
DELETE FROM QUERY_MASTER WHERE CODE='covid19_dashboard_testing_status_table';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
75398,  current_date , 75398,  current_date , 'covid19_dashboard_testing_status_table', 
 null, 
'with admission_wise_counts as (
select covid_admission_detail_id,
count(*) as total_entries,
count(*) filter (where lab_collection_status in (''SAMPLE_COLLECTED'',''SAMPLE_ACCEPTED'',''POSITIVE'',''NEGATIVE'',''INDETERMINATE'')) as samples_collected,
count(*) filter (where lab_collection_status = ''SAMPLE_COLLECTED'') as sample_in_transit,
count(*) filter (where lab_collection_status = ''POSITIVE'') as positive,
count(*) filter (where lab_collection_status = ''NEGATIVE'') as negative,
count(*) filter (where lab_collection_status in (''SAMPLE_ACCEPTED'',''INDETERMINATE'')) as result_pending
from covid19_lab_test_detail
group by covid_admission_detail_id
)select count(*) filter (where samples_collected > 0) as "samplesCollected",
count(*) filter (where sample_in_transit > 0) as "samplesInTransit",
count(*) filter (where positive > 0) as "positive",
count(*) filter (where total_entries = negative) as "negative",
count(*) filter (where result_pending > 0) as "resultPending"
from admission_wise_counts', 
null, 
true, 'ACTIVE');