ALTER TABLE IF EXISTS ncd_member_hypertension_detail
 ADD COLUMN IF NOT EXISTS status character varying(50);

ALTER TABLE IF EXISTS ncd_member_diabetes_detail
 ADD COLUMN IF NOT EXISTS status character varying(50);

ALTER TABLE IF EXISTS ncd_member_diabetes_detail
 ADD COLUMN IF NOT EXISTS does_suffering boolean;

ALTER TABLE IF EXISTS ncd_member_disesase_medicine
 ADD COLUMN IF NOT EXISTS frequency integer;

ALTER TABLE IF EXISTS ncd_member_disesase_medicine
 ADD COLUMN IF NOT EXISTS duration integer;

ALTER TABLE IF EXISTS ncd_member_disesase_medicine
 ADD COLUMN IF NOT EXISTS quantity integer;

ALTER TABLE IF EXISTS ncd_member_disesase_medicine
 ADD COLUMN IF NOT EXISTS special_instruction text;