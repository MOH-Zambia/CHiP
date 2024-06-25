ALTER TABLE public.ncd_dell_api_push_response ADD COLUMN IF NOT EXISTS data_to_json text NULL;
ALTER TABLE public.ncd_dell_api_push_response ADD COLUMN IF NOT EXISTS uri text NULL;