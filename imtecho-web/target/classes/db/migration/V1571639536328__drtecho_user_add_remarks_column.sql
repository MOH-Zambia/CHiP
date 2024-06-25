ALTER TABLE um_drtecho_user
DROP COLUMN IF EXISTS remarks,
ADD COLUMN remarks text;
