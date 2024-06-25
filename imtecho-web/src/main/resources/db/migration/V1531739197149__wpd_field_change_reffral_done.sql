ALTER TABLE rch_wpd_mother_master
DROP COLUMN if exists referral_done, ADD COLUMN referral_done character varying(15);

ALTER TABLE rch_pnc_child_master
DROP COLUMN if exists child_referral_done, ADD COLUMN child_referral_done character varying(15);

ALTER TABLE rch_pnc_mother_master
DROP COLUMN if exists mother_referral_done, ADD COLUMN mother_referral_done character varying(15);