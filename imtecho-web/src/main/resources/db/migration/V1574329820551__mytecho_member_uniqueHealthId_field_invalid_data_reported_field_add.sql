ALTER TABLE public.mytecho_member
DROP COLUMN IF EXISTS unique_health_id,
ADD COLUMN unique_health_id text;

ALTER TABLE public.mytecho_member
DROP COLUMN IF EXISTS invalid_data_details,
ADD COLUMN invalid_data_details text;

ALTER TABLE public.mytecho_user
DROP COLUMN IF EXISTS is_invalid_data_reported,
ADD COLUMN is_invalid_data_reported boolean;
