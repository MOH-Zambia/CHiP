ALTER TABLE drtecho_health_facility_reg
DROP COLUMN IF EXISTS remarks,
ADD COLUMN remarks text;