ALTER TABLE imt_member
DROP COLUMN IF EXISTS cur_preg_reg_date,
ADD COLUMN cur_preg_reg_date timestamp without time zone;