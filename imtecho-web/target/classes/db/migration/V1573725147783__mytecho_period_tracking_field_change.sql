ALTER TABLE public.mytecho_period_tracking_detail
DROP COLUMN IF EXISTS start_date,
ADD COLUMN start_date timestamp without time zone;

ALTER TABLE public.mytecho_period_tracking_detail
DROP COLUMN IF EXISTS end_date,
ADD COLUMN end_date timestamp without time zone;