-- Add column in um_role_master
ALTER TABLE um_role_master
DROP COLUMN IF EXISTS role_type,
ADD COLUMN role_type text;
