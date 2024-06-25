ALTER TABLE rch_pnc_mother_master
DROP COLUMN if exists other_death_reason, ADD COLUMN other_death_reason character varying(50);