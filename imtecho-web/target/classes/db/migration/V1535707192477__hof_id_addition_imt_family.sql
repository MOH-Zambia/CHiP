ALTER TABLE public.imt_family
DROP COLUMN IF EXISTS hof_id,
ADD COLUMN hof_id bigint;