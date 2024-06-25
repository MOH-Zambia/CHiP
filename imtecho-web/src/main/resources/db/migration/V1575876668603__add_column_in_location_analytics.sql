DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_10_to_14_male bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_10_to_14_female bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column total_15_to_18_male bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;