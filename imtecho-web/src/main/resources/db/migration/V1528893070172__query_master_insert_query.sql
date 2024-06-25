delete from query_master where code = 'mob_notification_mark_as_complete';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mob_notification_mark_as_complete', 'action_by,notification_id', 'update techo_notification_master set state = ''COMPLETED'' , action_by =#action_by#,modified_by =#action_by#,modified_on = now()  where id = #notification_id#'
, true, 'ACTIVE', 'This query will mark the mobile notification as complete.');


delete from query_master where code = 'mob_notification_reschedule';

INSERT INTO public.query_master(
            created_by,created_on,code, params, 
            query, returns_result_set, state, description)
    VALUES (1,now(),'mob_notification_reschedule', 'action_by,schedule_days_add,due_days_add,expiary_days_add,notification_id'
, 'update techo_notification_master set state = ''RESCHEDULE'',modified_by =#action_by#,modified_on = now()
,schedule_date = schedule_date + #schedule_days_add# * INTERVAL ''1 day''
,due_on = case when ''#due_days_add#'' != ''null'' then (schedule_date + #schedule_days_add# * INTERVAL ''1 day'') + #due_days_add# * INTERVAL ''1 day'' 
else due_on end,
expiry_date = case when ''#expiary_days_add#'' != ''null'' then (schedule_date + #schedule_days_add# * INTERVAL ''1 day'') + #expiary_days_add# * INTERVAL ''1 day'' 
else expiry_date end
where id = #notification_id#;'
, true, 'ACTIVE', 'This query will mark the mobile notification as complete.');
