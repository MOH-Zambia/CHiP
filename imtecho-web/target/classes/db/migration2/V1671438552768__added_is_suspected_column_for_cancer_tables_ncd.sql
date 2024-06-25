ALTER TABLE IF EXISTS ncd_member_oral_detail ADD COLUMN IF NOT EXISTS is_suspected boolean;
ALTER TABLE IF EXISTS ncd_member_breast_detail ADD COLUMN IF NOT EXISTS is_suspected boolean;
ALTER TABLE IF EXISTS ncd_member_cervical_detail ADD COLUMN IF NOT EXISTS is_suspected boolean;