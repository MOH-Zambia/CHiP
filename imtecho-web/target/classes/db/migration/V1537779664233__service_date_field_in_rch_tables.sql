ALTER TABLE public.rch_anc_master
DROP COLUMN IF EXISTS service_date,
ADD COLUMN service_date timestamp without time zone;

ALTER TABLE public.rch_lmp_follow_up
DROP COLUMN IF EXISTS service_date,
ADD COLUMN service_date timestamp without time zone;

ALTER TABLE public.rch_pnc_master
DROP COLUMN IF EXISTS service_date,
ADD COLUMN service_date timestamp without time zone;

ALTER TABLE public.rch_child_service_master
DROP COLUMN IF EXISTS service_date,
ADD COLUMN service_date timestamp without time zone;