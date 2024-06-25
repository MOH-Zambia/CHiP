ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS haemoglobin_count,
ADD COLUMN haemoglobin_count real;