
DO $$ 
    BEGIN
        BEGIN
        
	alter table health_infrastructure_type_location add column location_type varchar(10);
    comment on column health_infrastructure_type_location.location_type is 'Health Infra Location Type';
EXCEPTION
        
            WHEN duplicate_column THEN 
            
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;