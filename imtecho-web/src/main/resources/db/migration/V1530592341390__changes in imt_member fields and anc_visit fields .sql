ALTER TABLE imt_member 
DROP COLUMN if exists mother_id, ADD COLUMN mother_id bigint;

ALTER TABLE imt_member 
DROP COLUMN if exists year_of_wedding, ADD COLUMN year_of_wedding int2;

ALTER TABLE rch_anc_master
DROP COLUMN if exists family_planning_method, ADD COLUMN family_planning_method character varying(50);

ALTER TABLE rch_anc_master
DROP COLUMN if exists foetal_position, ADD COLUMN foetal_position character varying(50);

ALTER TABLE rch_anc_master
DROP COLUMN if exists dangerous_sign_id, ADD COLUMN dangerous_sign_id character varying(50);