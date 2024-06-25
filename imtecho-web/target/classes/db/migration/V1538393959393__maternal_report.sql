DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE location_wise_month_year_analytics ADD COLUMN no_of_home_del_with_lmp integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE location_wise_month_year_analytics ADD COLUMN no_of_missing_del integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column already exists';
        END;
    END;
$$;    
    
