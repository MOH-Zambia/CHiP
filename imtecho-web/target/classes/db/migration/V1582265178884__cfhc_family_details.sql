DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_single_member_existing_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_single_member_newly_added_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_two_member_existing_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_two_member_newly_added_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_three_member_existing_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_three_member_newly_added_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_more_then_three_member_existing_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$
    BEGIN
        BEGIN
            alter table location_wise_analytics add column chfc_more_then_three_member_newly_added_families int;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
