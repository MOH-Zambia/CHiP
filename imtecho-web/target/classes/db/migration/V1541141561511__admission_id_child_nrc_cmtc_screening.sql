ALTER TABLE public.child_cmtc_nrc_screening_detail
DROP COLUMN IF EXISTS admission_id,
ADD COLUMN admission_id bigint;