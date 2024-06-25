ALTER TABLE imt_member
DROP COLUMN IF EXISTS cur_preg_reg_det_id,
ADD COLUMN cur_preg_reg_det_id bigint;

ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id,
ADD COLUMN cur_preg_reg_det_id bigint;

ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id,
ADD COLUMN cur_preg_reg_det_id bigint;

ALTER TABLE rch_pnc_master
DROP COLUMN IF EXISTS cur_preg_reg_det_id,
ADD COLUMN cur_preg_reg_det_id bigint;

ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS sugar_test_after_food_val,
ADD COLUMN sugar_test_after_food_val integer;

ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS sugar_test_before_food_val,
ADD COLUMN sugar_test_before_food_val integer;

ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS blood_sugar_test_value;

--- rch_pregnancy_registration_det
CREATE TABLE IF NOT EXISTS public.rch_pregnancy_registration_det
(
  id bigserial, 
  mthr_reg_no text, 
  member_id bigint, 
  lmp_date date, 
  edd date, 
  reg_date timestamp without time zone, 
  state text, 
  created_on timestamp without time zone, 
  created_by bigint, 
  modified_on timestamp without time zone, 
  modified_by bigint, 
  PRIMARY KEY (id)
);
