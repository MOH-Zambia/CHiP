-- current_para and current_gravida fields added to rch_asha_lmp_follow_up table

ALTER TABLE rch_asha_lmp_follow_up
DROP COLUMN IF EXISTS current_gravida,
ADD COLUMN current_gravida SMALLINT,
DROP COLUMN IF EXISTS current_para,
ADD COLUMN current_para SMALLINT;