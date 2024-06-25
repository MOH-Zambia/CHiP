DO $$
BEGIN
    BEGIN
       alter table rch_pregnancy_analytics_details add column is_fru boolean;
    EXCEPTION
        WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
    END;
END;
$$;