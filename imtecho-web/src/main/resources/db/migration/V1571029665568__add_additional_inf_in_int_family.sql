ALTER TABLE imt_family
DROP COLUMN IF EXISTS additional_info,
ADD COLUMN additional_info text;

