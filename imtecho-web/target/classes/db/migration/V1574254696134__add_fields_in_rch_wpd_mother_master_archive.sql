ALTER TABLE rch_wpd_mother_master_archive
DROP COLUMN if exists fbmdsr,
DROP COLUMN if exists referral_infra_id,
DROP COLUMN if exists death_infra_id;

ALTER TABLE rch_wpd_mother_master_archive
ADD COLUMN fbmdsr boolean,
ADD COLUMN referral_infra_id bigint,
ADD COLUMN death_infra_id bigint;