ALTER TABLE rch_lmp_follow_up
DROP COLUMN if exists other_death_reason, ADD COLUMN other_death_reason character varying(50);