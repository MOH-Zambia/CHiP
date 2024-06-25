ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS mytecho_member_id,
ADD COLUMN mytecho_member_id bigint,
DROP COLUMN IF EXISTS is_gujarat_user,
ADD COLUMN is_gujarat_user boolean;