DO $$
    BEGIN
        BEGIN
            alter table sms_staff_sms_master 
                add column created_by integer ,
                add column created_on timestamp without time zone,
                add column modified_by integer,
                add column modified_on timestamp without time zone;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;


UPDATE menu_config
SET feature_json ='{"canViewSelfSms":false, "canViewAllSms":false}'
WHERE menu_name = 'Staff Sms Configuration';


-- Created query to fetch staff sms config by user id for canViewSelf rights.

DELETE FROM query_master where code='retrieve_staff_sms_by_userid';

INSERT INTO public.query_master
( created_by, created_on, code, params, query, returns_result_set, state, description)
VALUES(1, now(), 'retrieve_staff_sms_by_userid', 'userId', 'select sms_template as "smsTemplate", trigger_type as "triggerType", schedule_date_time as "dateTime", *  from sms_staff_sms_master where created_by = ''#userId#'';', true, 'ACTIVE', NULL);
