ALTER TABLE IF EXISTS ncd_member_breast_detail
 DROP COLUMN IF EXISTS consistency_of_lumps,
 DROP COLUMN IF EXISTS discharge_from_nipples,
 DROP COLUMN IF EXISTS other_symptoms,
 DROP COLUMN IF EXISTS skin_dimpling,
 DROP COLUMN IF EXISTS is_retraction_of_skin,
 DROP COLUMN IF EXISTS size_change_left,
 DROP COLUMN IF EXISTS size_change_right,
 DROP COLUMN IF EXISTS retraction_of_left_nipple,
 DROP COLUMN IF EXISTS retraction_of_right_nipple,
 DROP COLUMN IF EXISTS discharge_from_left_nipple,
 DROP COLUMN IF EXISTS discharge_from_right_nipple,
 DROP COLUMN IF EXISTS left_lymphadenopathy,
 DROP COLUMN IF EXISTS right_lymphadenopathy;

ALTER TABLE IF EXISTS ncd_member_breast_detail
 ADD COLUMN IF NOT EXISTS status character varying(50),
 ADD COLUMN IF NOT EXISTS does_suffering boolean,
 ADD COLUMN IF NOT EXISTS retraction_of_skin_flag boolean;

ALTER TABLE IF EXISTS ncd_member_cervical_detail
 ALTER COLUMN via_test TYPE character varying(50);
ALTER TABLE IF EXISTS ncd_member_cervical_detail
 ADD COLUMN IF NOT EXISTS status character varying(50);

ALTER TABLE IF EXISTS ncd_member_oral_detail
 ADD COLUMN IF NOT EXISTS status character varying(50),
 ADD COLUMN IF NOT EXISTS ulcer text,
 ADD COLUMN IF NOT EXISTS does_suffering boolean;