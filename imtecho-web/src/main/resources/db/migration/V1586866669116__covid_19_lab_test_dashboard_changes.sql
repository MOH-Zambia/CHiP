DELETE FROM QUERY_MASTER WHERE CODE='lab_test_dashboard_mark_sample_received_status';

INSERT INTO public.QUERY_MASTER ( created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
60512,  current_date , 60512,  current_date , 'lab_test_dashboard_mark_sample_received_status',
'receiveDate,rejectionRemarks,labTestNumber,id,userId,status',
'update covid19_lab_test_detail
set lab_collection_status = ''#status#'',
lab_sample_rejected_by = case when ''#status#'' = ''SAMPLE_REJECTED'' then #userId# else null end,
lab_sample_rejected_on = case when ''#status#'' = ''SAMPLE_REJECTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_sample_reject_reason = ''#rejectionRemarks#'',
lab_sample_received_by = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then #userId# else null end,
lab_sample_received_on = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then to_timestamp(''#receiveDate#'',''DD/MM/YYYY HH24:MI:SS'') else null end,
lab_test_number = case when ''#status#'' = ''SAMPLE_ACCEPTED'' then ''#labTestNumber#'' else null end,
receive_server_date = now()
where id = #id#;',
null,
false, 'ACTIVE');