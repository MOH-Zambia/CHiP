ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS state,
ADD COLUMN state text;