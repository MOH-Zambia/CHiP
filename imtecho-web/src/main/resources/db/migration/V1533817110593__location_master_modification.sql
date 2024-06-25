DO $$
    BEGIN
        BEGIN
	alter table location_master add column location_flag varchar(255);
EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Already exists';
 END;
    END;
$$;
