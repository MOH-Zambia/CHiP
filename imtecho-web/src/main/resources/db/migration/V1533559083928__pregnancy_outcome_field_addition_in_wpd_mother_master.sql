ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS pregnancy_outcome,
ADD COLUMN pregnancy_outcome character varying(15);