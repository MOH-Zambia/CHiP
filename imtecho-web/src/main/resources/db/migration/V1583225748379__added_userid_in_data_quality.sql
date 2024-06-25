DO $$
BEGIN
    BEGIN
       alter table rch_data_quality_analytics add column user_id int;
    EXCEPTION
        WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
    END;
END;
$$;