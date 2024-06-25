DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_anc_master ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <rch_anc_master>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_anc_master ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <rch_anc_master>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_pnc_master ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <rch_pnc_master>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_pnc_master ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <rch_pnc_master>.';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_child_service_master ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <rch_child_service_master>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_child_service_master ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <rch_child_service_master>.';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_immunisation_master ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <rch_immunisation_master>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE rch_immunisation_master ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <rch_immunisation_master>.';
        END;
    END;
$$;



DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_hypertension_detail ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_hypertension_detail>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_hypertension_detail ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_hypertension_detail>.';
        END;
    END;
$$;



DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_diabetes_detail ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_diabetes_detail>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_diabetes_detail ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_diabetes_detail>.';
        END;
    END;
$$;



DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_oral_detail ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_oral_detail>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_oral_detail ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_oral_detail>.';
        END;
    END;
$$;



DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_breast_detail ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_breast_detail>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_breast_detail ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_breast_detail>.';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_cervical_detail ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_cervical_detail>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_cervical_detail ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_cervical_detail>.';
        END;
    END;
$$;


DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_diseases_diagnosis ADD COLUMN hmis_health_infra_id integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_id> already exists in <ncd_member_diseases_diagnosis>.';
        END;
    END;
$$;

DO $$ 
    BEGIN
        BEGIN
            ALTER TABLE ncd_member_diseases_diagnosis ADD COLUMN hmis_health_infra_type integer;
        EXCEPTION
            WHEN duplicate_column THEN RAISE NOTICE 'column <hmis_health_infra_type> already exists in <ncd_member_diseases_diagnosis>.';
        END;
    END;
$$;




-- This is for issue 4275

CREATE OR REPLACE FUNCTION public.covid19_addmission_insert_update_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	NEW.search_text = concat_ws(' ',NEW.first_name,NEW.middle_name,NEW.last_name,NEW.case_no,NEW.unit_no,NEW.opd_case_no,NEW.current_bed_no,NEW.contact_number,(select ward_name from health_infrastructure_ward_details where id = NEW.current_ward_id));
	/*if NEW.lab_test_id is null then
	update covid19_lab_test_detail set created_by = created_by where covid_admission_detail_id = NEW.id and covid19_lab_test_detail.lab_test_id is null;
	end if; */
   RETURN NEW;
END;
$function$
;
