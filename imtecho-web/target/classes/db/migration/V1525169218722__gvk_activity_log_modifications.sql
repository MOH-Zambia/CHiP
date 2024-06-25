DO $$ 
    BEGIN
        BEGIN
        alter table gvk_activity_log 
        add column break_time bigint;
        EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

alter table gvk_activity_log 
drop column if exists userid;