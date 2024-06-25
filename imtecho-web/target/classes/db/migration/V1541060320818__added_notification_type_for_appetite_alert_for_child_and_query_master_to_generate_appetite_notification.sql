DELETE FROM notification_type_master where code = 'APPETITE';
INSERT INTO notification_type_master (created_by, created_on, modified_by, modified_on, code, name, type, role_id, state, notification_for)
VALUES(-1, now(), -1, now(), 'APPETITE', 'Appetite Test Alert For Child', 'MO', 30, 'ACTIVE', 'MEMBER');

DELETE FROM public.query_master where code = 'generate_appetite_test_notification';
INSERT INTO public.query_master(
    created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES (1, localtimestamp, 'generate_appetite_test_notification', 
    'location_id,location_hierarchy_id,family_id,member_id,created_by,id', 
    'INSERT INTO techo_notification_master(notification_type_id, notification_code, location_id, location_hierchy_id, 
        family_id, member_id, schedule_date, state, created_by, created_on, modified_by, modified_on, related_id) 
        SELECT (SELECT id FROM notification_type_master WHERE code = ''APPETITE''), 
        ''0'', #location_id#, #location_hierarchy_id#, #family_id#, #member_id#, now(), ''PENDING'', #created_by#, now(), #created_by#, now(), #id#
        WHERE NOT EXISTS (SELECT * FROM child_cmtc_nrc_screening_detail where child_id = #member_id#);
    INSERT INTO child_cmtc_nrc_screening_detail (child_id, screened_on, location_id, location_hierarchy_id, state, 
        created_on, created_by, modified_on, modified_by)
        SELECT #member_id#, now(), #location_id#, #location_hierarchy_id#, ''ACTIVE'', now(), #created_by#, now(), #created_by#
        WHERE NOT EXISTS (SELECT * FROM child_cmtc_nrc_screening_detail where child_id = #member_id#);', 
    false, 'ACTIVE', 'It will generate the notification for Appetite Test Alert For Child');

ALTER TABLE child_cmtc_nrc_screening_detail 
DROP COLUMN IF EXISTS appetite_test_done, 
ADD COLUMN appetite_test_done character varying(10);

ALTER TABLE child_cmtc_nrc_screening_detail 
DROP COLUMN IF EXISTS appetite_test_reported_on, 
ADD COLUMN appetite_test_reported_on timestamp without time zone;