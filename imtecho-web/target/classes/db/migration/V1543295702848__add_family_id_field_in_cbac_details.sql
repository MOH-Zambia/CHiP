ALTER TABLE ncd_member_cbac_detail
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;