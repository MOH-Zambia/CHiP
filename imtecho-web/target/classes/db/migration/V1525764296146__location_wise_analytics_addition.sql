DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_family bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_members bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_alive bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_male bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_female bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_women bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_children bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_adolescents bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
