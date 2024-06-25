DO $$ 
    BEGIN
        BEGIN
        ALTER TABLE public.um_role_master
            ADD COLUMN max_position integer;
EXCEPTION
            WHEN duplicate_column THEN 
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;