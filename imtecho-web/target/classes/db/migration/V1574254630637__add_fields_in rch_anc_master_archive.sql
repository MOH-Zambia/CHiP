ALTER TABLE rch_anc_master_archive
DROP COLUMN if exists death_infra_id,
DROP COLUMN if exists examined_by_gynecologist ,
DROP COLUMN if exists is_inj_corticosteroid_given ;


ALTER TABLE rch_anc_master_archive
ADD COLUMN death_infra_id bigint,
ADD COLUMN examined_by_gynecologist boolean,
ADD COLUMN is_inj_corticosteroid_given boolean;