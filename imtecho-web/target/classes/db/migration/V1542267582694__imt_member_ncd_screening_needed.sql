ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS ncd_screening_needed,
ADD COLUMN ncd_screening_needed boolean;

ALTER TABLE public.ncd_member_cbac_detail
DROP COLUMN IF EXISTS score,
ADD COLUMN score integer;