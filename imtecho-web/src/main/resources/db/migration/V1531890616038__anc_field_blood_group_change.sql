ALTER TABLE rch_anc_master 
DROP COLUMN IF EXISTS blood_group,
ADD COLUMN blood_group character varying(3);
