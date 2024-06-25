DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN tt1 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN tt2_booster integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN anc1 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN anc2 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;
DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN anc3 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN anc4 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN mtp integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN abortion integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN pnc1 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN pnc2 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN pnc3 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN pnc4 integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN maternal_death integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN anc_regd integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN early_anc integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_wise_rch_reports_analytics ADD COLUMN no_del integer;
EXCEPTION
        
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;