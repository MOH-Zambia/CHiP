BEGIN;

ALTER TABLE malaria_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE malaria_index_case_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE malaria_non_index_case_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE tuberculosis_screening_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE covid_screening_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_preg_hiv_positive_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_hiv_screening_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_hiv_known_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_lmp_follow_up ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_anc_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_wpd_mother_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_wpd_child_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_pnc_mother_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_pnc_child_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE rch_child_service_master ADD COLUMN IF NOT EXISTS form_filled_via TEXT;
ALTER TABLE emtct_details ADD COLUMN IF NOT EXISTS form_filled_via TEXT;

COMMIT;