DO $$
    BEGIN
        BEGIN
            CREATE TABLE rch_pmsma_service_statistics_during_year (
            	location_id int4 NOT NULL,
            	financial_year text NULL,
            	high_risk_mother_under_techo int4 NULL,
            	total_anc_under_pmsma int4 NULL,
            	total_beneficiary_under_pmsma_at_least_once int4 NULL,
            	CONSTRAINT rch_pmsma_service_statistics_during_year_pkey PRIMARY KEY (location_id, financial_year)
            );
        EXCEPTION
            WHEN duplicate_table THEN RAISE NOTICE 'rch_pmsma_service_statistics_during_year table already exists.';
        END;
    END;
$$;