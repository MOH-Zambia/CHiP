/*alter table covid19_lab_test_detail
drop column if exists collection_server_date,
drop column if exists receive_server_date,
drop column if exists indeterminate_server_date,
drop column if exists result_server_date,
add column collection_server_date timestamp without time zone,
add column receive_server_date timestamp without time zone,
add column indeterminate_server_date timestamp without time zone,
add column result_server_date timestamp without time zone;

begin;
update covid19_lab_test_detail
set collection_server_date = lab_collection_on
where collection_server_date is null;
commit;

begin;
update covid19_lab_test_detail
set receive_server_date = case when lab_sample_received_on is null then lab_sample_rejected_on else lab_sample_received_on end
where receive_server_date is null;
commit;

begin;
update covid19_lab_test_detail
set indeterminate_server_date = indeterminate_marked_date
where indeterminate_server_date is null;
commit;

begin;
update covid19_lab_test_detail
set result_server_date = lab_result_entry_on
where result_server_date is null;
commit;

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_save_sample_collection';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_save_sample_collection',
'healthInfraId,id,collectionDate,userId',
'update covid19_lab_test_detail
set sample_health_infra_send_to = case when ''#healthInfraId#'' = ''null'' then sample_health_infra else #healthInfraId# end,
lab_collection_on = to_timestamp(''#collectionDate#'',''DD/MM/YYYY HH24:MI:SS''),
lab_collection_entry_by = #userId#,
lab_collection_status = ''SAMPLE_COLLECTED'',
collection_server_date = now()
where id = #id#;',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_sample_received_status';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_sample_received_status',
'receiveDate,rejectionRemarks,labTestNumber,id,userId,status',
'update covid19_lab_test_detail
set lab_collection_status = ''#status#'',
lab_sample_rejected_by = case when ''#status#'' = ''SAMPLE_REJECTED'' then #userId# else null end,
lab_sample_rejected_on = case when ''#status#'' = ''SAMPLE_REJECTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_sample_reject_reason = case when ''#status#'' = ''SAMPLE_REJECTED'' then ''#rejectionRemarks#'' else null end,
lab_sample_received_by = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then #userId# else null end,
lab_sample_received_on = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_test_number = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then ''#labTestNumber#'' else null end,
receive_server_date = now()
where id = #id#;',
null,
false, 'ACTIVE');

DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_indeterminate';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_indeterminate',
'resultDate,id,userId',
'update covid19_lab_test_detail
set lab_result = ''INDETERMINATE'',
is_indeterminate = true,
indeterminate_marked_date =  to_timestamp(''#resultDate#'',''DD/MM/YYYY HH24:MI:SS''),
indeterminate_marked_by = #userId#,
lab_collection_status = ''INDETERMINATE'',
indeterminate_server_date = now()
where id = #id#;',
null,
false, 'ACTIVE');

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
indeterminate_lab_name = (case when ''#labName#'' = ''null'' then indeterminate_lab_name else ''#labName#'' end),
result_server_date = now()
where id = #id#;',
null,
false, 'ACTIVE');
*/