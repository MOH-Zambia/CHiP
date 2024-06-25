ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS pincode,
ADD COLUMN pincode int;