ALTER TABLE IF EXISTS ncd_member_initial_assessment_detail ADD COLUMN IF NOT EXISTS master_id integer;
ALTER TABLE IF EXISTS ncd_member_general_detail ADD COLUMN IF NOT EXISTS master_id integer;