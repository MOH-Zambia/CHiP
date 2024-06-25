
ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS drive_last_backup_date,
ADD COLUMN drive_last_backup_date timestamp without time zone;

ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS drive_backup_folder_name,
ADD COLUMN drive_backup_folder_name text;

ALTER TABLE mytecho_user
DROP COLUMN IF EXISTS drive_backup_account_id,
ADD COLUMN drive_backup_account_id text;