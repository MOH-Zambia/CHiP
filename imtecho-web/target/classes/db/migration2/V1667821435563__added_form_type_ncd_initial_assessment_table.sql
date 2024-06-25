ALTER TABLE IF EXISTS ncd_member_initial_assessment_detail
 ADD COLUMN IF NOT EXISTS form_type character varying(50);