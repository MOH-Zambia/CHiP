DELETE FROM QUERY_MASTER WHERE CODE='covid19_edit_lab_result';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
409,  current_date , 409,  current_date , 'covid19_edit_lab_result', 
'result,otherResultRemarksSelected,resultDate,labName,isRecollect,id,userId,resultRemarks', 
'with admission_det as ( 
select cltd.covid_admission_detail_id as admission_id
from covid19_lab_test_detail cltd where id = #id#
),sample_count_det as(
select count(1) as sample_count from covid19_lab_test_detail cltd where cltd.covid_admission_detail_id = (select admission_id from admission_det) 
),update_admission_status as (
update covid19_admission_detail
set status = (case when scd.sample_count = 1 and ''#result#'' = ''POSITIVE'' then ''CONFORMED''
when scd.sample_count = 1 then ''SUSPECTED''
else status end)
from sample_count_det scd
where id = (select admission_id from admission_det) and status in (''CONFORMED'',''SUSPECTED'')
)
update covid19_lab_test_detail
set lab_result_entry_on = to_timestamp(''#resultDate#'',''DD/MM/YYYY HH24:MI:SS''),
lab_result_entry_by = #userId#,
lab_result = ''#result#'',
lab_collection_status = ''#result#'',
indeterminate_lab_name = (case when ''#labName#'' = ''null'' then indeterminate_lab_name else ''#labName#'' end),
result_remarks = (case when ''#resultRemarks#'' = ''null'' then null else ''#resultRemarks#'' end),
is_recollect = #isRecollect#,
other_result_remarks_selected = (case when ''#otherResultRemarksSelected#'' = ''null'' then null else ''#otherResultRemarksSelected#'' end),
result_server_date = now()
where id = #id#;', 
null, 
false, 'ACTIVE');



UPDATE menu_config
SET feature_json='{"canSampleCollect" : false, "canSampleReceive" : false, "canSampleResult" : false,"canIndeterminate":false,"canTransfer":false,"canResultConfirm":false,"canEditResult":false}' WHERE menu_name='Lab';
