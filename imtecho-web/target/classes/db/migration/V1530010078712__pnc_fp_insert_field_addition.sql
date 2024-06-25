ALTER TABLE rch_pnc_mother_master
DROP COLUMN IF EXISTS fp_insert_operate_date,
ADD COLUMN fp_insert_operate_date timestamp without time zone;

ALTER TABLE rch_pnc_child_master
DROP COLUMN IF EXISTS referral_place,
ADD COLUMN referral_place bigint;