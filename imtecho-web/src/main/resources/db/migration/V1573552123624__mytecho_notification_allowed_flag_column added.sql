ALTER TABLE public.mytecho_user
DROP COLUMN IF EXISTS is_notification_allowed,
ADD COLUMN is_notification_allowed boolean;