DO $$
    BEGIN
        BEGIN
            ALTER TABLE rch_pmsma_service_statatics ADD COLUMN total_beneficiary_under_pmsma_at_least_once integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
        END;
    END;
$$;