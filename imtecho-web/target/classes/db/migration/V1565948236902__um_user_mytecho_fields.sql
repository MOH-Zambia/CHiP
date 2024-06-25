ALTER TABLE um_user
DROP COLUMN IF EXISTS member_id,
ADD COLUMN member_id bigint,
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS pincode,
ADD COLUMN pincode integer;