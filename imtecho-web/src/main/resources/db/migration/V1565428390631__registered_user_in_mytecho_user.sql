ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS registered_user,
ADD COLUMN registered_user boolean;