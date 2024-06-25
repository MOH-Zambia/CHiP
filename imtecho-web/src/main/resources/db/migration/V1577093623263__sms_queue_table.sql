drop table if exists sms_queue;

create table sms_queue
(
    id serial primary key,
    mobile_number text,
    message character varying(500),
    message_type  character varying(30),
    status character varying(20),
    is_processed boolean,
    is_sent boolean,
    processed_on timestamp without time zone,
    created_on timestamp without time zone,
    completed_on timestamp without time zone,
    exception_string text
);

DO $$
    BEGIN
        BEGIN
            alter table sms 
                add column message_type character varying(40),
                add column status character varying(20),
                add column exception_string character varying(100),
                add column response_id character varying(40),
                add column carrier_status character varying(20);
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

-- To set response id in every row of sms table. 
update sms set response_id = substring(response from '=(.+)~');

-- update sms sm
-- set carrier_status = carrierstatus 
-- from sms_response sr
-- where sr.a2wackid = sm.response_id and sm.created_on::date <= CURRENT_DATE - interval '3' day;

DO $$
    BEGIN
        BEGIN
            alter table event_configuration_type 
                add column sms_config_json text;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column sms_config_json already exists';
        END;
    END;
$$;