DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column child_0_5 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column child_dead bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column child_new bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column child_migrated bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;