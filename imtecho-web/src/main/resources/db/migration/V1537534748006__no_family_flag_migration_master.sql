ALTER TABLE public.migration_master
DROP COLUMN IF EXISTS no_family,
ADD COLUMN no_family boolean;