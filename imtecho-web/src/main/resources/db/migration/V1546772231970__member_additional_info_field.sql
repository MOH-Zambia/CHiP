ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS additional_info,
ADD COLUMN additional_info text;