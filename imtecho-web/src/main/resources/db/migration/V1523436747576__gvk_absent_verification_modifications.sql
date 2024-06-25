DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE absent_user_verification ADD COLUMN role_id bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE gvk_absent_verification ADD COLUMN start_work_reason bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;    
