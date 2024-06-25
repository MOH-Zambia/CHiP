DO $$
    BEGIN
        BEGIN
           alter table sms_queue
           add column sms_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;