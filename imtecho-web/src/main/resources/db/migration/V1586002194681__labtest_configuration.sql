alter table covid19_lab_test_detail
drop column if exists indeterminate_lab_name,
add column indeterminate_lab_name text;

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_result_status';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_result_status', 
'result,resultDate,labName,id,userId', 
'with admission_det as (
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id# and ''#result#'' = ''POSITIVE''
),update_admission_status as (
update covid19_admission_detail
set status = ''CONFORMED'' where id = (select admission_id from admission_det) and ''#result#'' = ''POSITIVE''
)
update covid19_lab_test_detail
set lab_result_entry_on = to_timestamp(''#resultDate#'',''DD/MM/YYYY HH24:MI:SS''),
lab_result_entry_by = #userId#,
lab_result = ''#result#'',
lab_collection_status = ''#result#'',
indeterminate_lab_name = (case when ''#labName#'' = ''null'' then indeterminate_lab_name else ''#labName#'' end)
where id = #id#;', 
null, 
false, 'ACTIVE');