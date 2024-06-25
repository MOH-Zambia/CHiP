ALTER TABLE rch_wpd_mother_master DROP COLUMN IF EXISTS is_discharged, ADD COLUMN is_discharged boolean;

ALTER TABLE techo_notification_master DROP COLUMN IF EXISTS related_id, ADD COLUMN related_id bigint;

INSERT INTO notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
VALUES(-1, now(), -1, now(), 'DISCHARGE', 'WPD Discharge Date Entry', 'MO', 30, 'ACTIVE', 'MEMBER');

DELETE FROM public.query_master where code = 'generate_discharge_notification';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'generate_discharge_notification', 
    'location_id,family_id,member_id,date_of_delivery,created_by,pregnancy_reg_det_id,id', 
    'INSERT INTO techo_notification_master(notification_type_id, notification_code, location_id, 
        family_id, member_id, schedule_date, due_on, state, created_by, created_on, modified_by, modified_on, 
        ref_code, related_id) 
    SELECT (SELECT id FROM notification_type_master WHERE code = ''DISCHARGE''), 
        ''0'', #location_id#, #family_id#, #member_id#, 
        CASE WHEN (CAST(''#date_of_delivery#'' AS DATE) + INTERVAL ''3 days'') > now() 
            THEN (CAST(''#date_of_delivery#'' AS DATE) + INTERVAL ''3 days'') ELSE now() END,
        CASE WHEN (CAST(''#date_of_delivery#'' AS DATE) + INTERVAL ''3 days'') > now() 
            THEN (CAST(''#date_of_delivery#'' AS DATE) + INTERVAL ''6 days'') ELSE now() + INTERVAL ''3 days'' END,
        ''PENDING'', #created_by#, now(), #created_by#, now(), #pregnancy_reg_det_id#, #id#;', 
    false, 'ACTIVE', 'It will generate the notification for Discharge Date Entry Form For WPD');