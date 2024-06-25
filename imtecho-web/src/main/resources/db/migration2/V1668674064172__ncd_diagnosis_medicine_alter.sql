ALTER TABLE IF EXISTS ncd_member_disesase_medicine
 ADD COLUMN IF NOT EXISTS expiry_date timestamp without time zone,
 ADD COLUMN IF NOT EXISTS is_active boolean;