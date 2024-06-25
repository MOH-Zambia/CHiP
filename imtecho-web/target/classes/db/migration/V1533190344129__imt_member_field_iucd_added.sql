ALTER TABLE imt_member
DROP COLUMN IF EXISTS is_iucd_removed,
ADD COLUMN is_iucd_removed boolean;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS iucd_removal_date,
ADD COLUMN iucd_removal_date timestamp without time zone;