ALTER TABLE imt_family
DROP COLUMN IF EXISTS remarks,
ADD COLUMN remarks text;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS remarks,
ADD COLUMN remarks text;