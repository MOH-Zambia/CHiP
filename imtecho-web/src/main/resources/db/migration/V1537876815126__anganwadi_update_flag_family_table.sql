ALTER TABLE public.imt_family
DROP COLUMN IF EXISTS anganwadi_update_flag,
ADD COLUMN anganwadi_update_flag boolean;