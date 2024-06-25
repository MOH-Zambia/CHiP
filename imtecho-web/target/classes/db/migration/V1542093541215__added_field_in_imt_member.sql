ALTER TABLE imt_member 
DROP COLUMN IF EXISTS hysterectomy_done,
ADD COLUMN hysterectomy_done boolean;