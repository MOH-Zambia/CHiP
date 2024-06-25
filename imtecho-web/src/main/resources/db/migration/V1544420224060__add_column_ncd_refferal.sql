ALTER TABLE ncd_member_referral
RENAME modifiedby TO modified_by;

ALTER TABLE ncd_member_oral_detail
DROP COLUMN IF EXISTS refferal_done,
ADD COLUMN refferal_done boolean,
DROP COLUMN IF EXISTS refferal_place,
ADD COLUMN refferal_place text;

ALTER TABLE ncd_member_breast_detail
DROP COLUMN IF EXISTS refferal_done,
ADD COLUMN refferal_done boolean,
DROP COLUMN IF EXISTS refferal_place,
ADD COLUMN refferal_place text;

