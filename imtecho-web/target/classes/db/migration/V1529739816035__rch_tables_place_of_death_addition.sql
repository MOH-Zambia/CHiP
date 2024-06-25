ALTER TABLE rch_child_service_master
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_pnc_mother_master
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_pnc_child_master
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_lmp_follow_up
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);