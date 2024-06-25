ALTER TABLE imt_family 
DROP COLUMN IF EXISTS any_member_cbac_done,
ADD COLUMN any_member_cbac_done boolean;