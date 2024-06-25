DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_member_death_deatil ADD COLUMN death_reason INTEGER;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'Column death_reason already exists in rch_member_death_deatil.';
        END;
    END;
$$