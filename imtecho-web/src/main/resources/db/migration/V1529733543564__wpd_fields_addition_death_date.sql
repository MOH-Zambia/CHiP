ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS death_date,
ADD COLUMN death_date timestamp without time zone;

ALTER TABLE rch_wpd_child_master
DROP COLUMN IF EXISTS death_date,
ADD COLUMN death_date timestamp without time zone;