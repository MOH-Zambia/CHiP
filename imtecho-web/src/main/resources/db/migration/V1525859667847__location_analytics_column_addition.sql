DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column blindness bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column tb bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_cell bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column diabetes bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column thalessemia bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column hiv bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column leprosy bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_male bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_female bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_0_5 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_5_15 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_15_45 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_above_45 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_bpl bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_apl bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_sc bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_st bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_obc bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_gen bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_abandon bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_married bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_unmarried bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_widow bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column sickle_widower bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column r11_15_49 bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column r11_migrated bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column r11_dead bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column r11_eligible_couple bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column new_fam bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column deleted_fam bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column new_mem bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
            alter table location_wise_analytics add column deleted_mem bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;