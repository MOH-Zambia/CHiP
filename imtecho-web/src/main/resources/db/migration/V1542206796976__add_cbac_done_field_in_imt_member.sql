ALTER TABLE imt_member 
DROP COLUMN IF EXISTS cbac_done,
ADD COLUMN cbac_done boolean;