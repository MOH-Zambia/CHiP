ALTER TABLE IF EXISTS ncd_member_hypertension_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;

ALTER TABLE IF EXISTS ncd_member_diabetes_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;

ALTER TABLE IF EXISTS ncd_member_mental_health_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;

ALTER TABLE IF EXISTS ncd_member_oral_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;

ALTER TABLE IF EXISTS ncd_member_breast_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;

ALTER TABLE IF EXISTS ncd_member_cervical_detail
ADD COLUMN IF NOT EXISTS take_medicine boolean,
ADD COLUMN IF NOT EXISTS is_htn boolean;