ALTER TABLE public.techo_web_notification_master
DROP COLUMN IF EXISTS action_taken,
ADD COLUMN action_taken text;