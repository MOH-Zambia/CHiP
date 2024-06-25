ALTER TABLE ncd_member_cbac_detail
DROP COLUMN IF EXISTS manual_verification,
ADD COLUMN manual_verification boolean;