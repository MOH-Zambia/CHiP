-- issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2988

ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS referral_infra_id,
ADD COLUMN referral_infra_id integer;


ALTER TABLE rch_pnc_mother_master
DROP COLUMN IF EXISTS referral_infra_id,
ADD COLUMN referral_infra_id integer;


ALTER TABLE rch_pnc_child_master
DROP COLUMN IF EXISTS referral_infra_id,
ADD COLUMN referral_infra_id integer;