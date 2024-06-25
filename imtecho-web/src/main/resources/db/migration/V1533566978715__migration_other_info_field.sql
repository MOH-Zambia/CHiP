ALTER TABLE public.migration_master
DROP COLUMN IF EXISTS other_information,
ADD COLUMN other_information text;