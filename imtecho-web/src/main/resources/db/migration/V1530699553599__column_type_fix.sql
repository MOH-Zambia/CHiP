DO $$ 
    BEGIN
        BEGIN
            alter table imt_member add column mother_id bigint;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'DUPLICATE COLUMNS';
        END;
    END;
$$;
alter table imt_member drop column if exists year_of_wedding;
alter table imt_member add column year_of_wedding int2;