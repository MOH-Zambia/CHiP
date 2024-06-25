DO $$
BEGIN
    BEGIN
       alter table rch_data_quality_analytics add column family_id varchar(255);
    EXCEPTION
        WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
    END;
END;
$$;