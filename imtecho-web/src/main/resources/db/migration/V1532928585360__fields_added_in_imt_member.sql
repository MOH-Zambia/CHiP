ALTER TABLE imt_member
DROP COLUMN IF EXISTS fp_insert_operate_date,
ADD COLUMN fp_insert_operate_date timestamp without time zone;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS menopause_arrived,
ADD COLUMN menopause_arrived boolean;