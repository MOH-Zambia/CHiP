ALTER TABLE system_sync_status 
DROP COLUMN IF EXISTS error_message,
ADD COLUMN error_message text;

ALTER TABLE system_sync_status 
DROP COLUMN IF EXISTS exception,
ADD COLUMN exception text;