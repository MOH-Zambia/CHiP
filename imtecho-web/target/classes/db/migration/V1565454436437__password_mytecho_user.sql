ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS password,
ADD COLUMN password text;