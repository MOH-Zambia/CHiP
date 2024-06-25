DO $$ 
    BEGIN
        BEGIN
	alter table location_wise_analytics add column chfc_remaining_family integer;
    comment on column location_wise_analytics.chfc_remaining_family is 'Chfc remaining family count';
EXCEPTION
        
            WHEN duplicate_column THEN 
            
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;