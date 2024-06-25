ALTER TABLE rch_anc_master
DROP COLUMN if exists foetal_movement, ADD COLUMN foetal_movement character varying(15);

ALTER TABLE rch_anc_master
DROP COLUMN if exists referral_done, ADD COLUMN referral_done character varying(15);

ALTER TABLE rch_anc_master
DROP COLUMN if exists urine_albumin, ADD COLUMN urine_albumin character varying(15);

ALTER TABLE rch_anc_master
DROP COLUMN if exists urine_sugar, ADD COLUMN urine_sugar character varying(15);