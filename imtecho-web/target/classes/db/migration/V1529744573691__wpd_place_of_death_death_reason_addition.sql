ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS death_reason,
ADD COLUMN death_reason character varying(50),
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20);

ALTER TABLE rch_wpd_child_master
DROP COLUMN IF EXISTS death_reason,
ADD COLUMN death_reason character varying(50),
DROP COLUMN IF EXISTS place_of_death,
ADD COLUMN place_of_death character varying(20),
DROP COLUMN IF EXISTS member_status,
ADD COLUMN member_status character varying (15);