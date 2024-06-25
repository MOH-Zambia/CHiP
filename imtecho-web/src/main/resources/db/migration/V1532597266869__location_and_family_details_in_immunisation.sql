ALTER TABLE rch_immunisation_master
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint,
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS location_hierarchy_id,
ADD COLUMN location_hierarchy_id bigint;
