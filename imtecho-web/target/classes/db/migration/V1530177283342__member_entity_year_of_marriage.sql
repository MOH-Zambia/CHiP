ALTER TABLE imt_member
DROP COLUMN IF EXISTS year_of_wedding,
ADD COLUMN year_of_wedding integer;