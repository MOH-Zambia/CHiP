ALTER TABLE imt_member
DROP COLUMN IF EXISTS blood_group,
ADD COLUMN blood_group character varying(3);

ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id;

ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id;

ALTER TABLE rch_pnc_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id;

ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS pregnancy_reg_det_id,
ADD COLUMN pregnancy_reg_det_id bigint;

ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS pregnancy_reg_det_id,
ADD COLUMN pregnancy_reg_det_id bigint;

ALTER TABLE rch_pnc_master
DROP COLUMN IF EXISTS pregnancy_reg_det_id,
ADD COLUMN pregnancy_reg_det_id bigint;