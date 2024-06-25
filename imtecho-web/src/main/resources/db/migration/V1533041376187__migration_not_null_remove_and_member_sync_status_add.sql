ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS sync_status,
ADD COLUMN sync_status text;

ALTER TABLE public.migration_master
   ALTER COLUMN member_id DROP NOT NULL;

ALTER TABLE public.migration_master
   ALTER COLUMN location_migrated_from DROP NOT NULL;