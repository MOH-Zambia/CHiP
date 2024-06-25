ALTER TABLE public.techo_notification_master
DROP COLUMN IF EXISTS migration_id,
ADD COLUMN migration_id bigint;