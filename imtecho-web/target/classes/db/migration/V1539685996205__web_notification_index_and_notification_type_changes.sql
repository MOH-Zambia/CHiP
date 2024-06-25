DROP INDEX IF EXISTS public.techo_web_notification_master_location_id_notification_type_idx;

CREATE INDEX techo_web_notification_master_location_id_notification_type_idx
  ON public.techo_web_notification_master
  USING btree
  (location_id, notification_type_escalation_id COLLATE pg_catalog."default", state COLLATE pg_catalog."default");

ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS data_query_id;
ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS action_query_id;

ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS data_query,
  ADD COLUMN data_query text;
ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS action_query,
  ADD COLUMN action_query text;

