ALTER TABLE rch_anc_master 
DROP COLUMN if exists death_reason,
ADD COLUMN death_reason character varying(50);

ALTER TABLE rch_child_service_master
DROP COLUMN if exists death_reason,
ADD COLUMN  death_reason character varying(50);