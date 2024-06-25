ALTER TABLE public.rch_pnc_mother_master
ADD COLUMN IF NOT EXISTS received_mebendazole BOOLEAN,
ADD COLUMN IF NOT EXISTS tetanus1_date timestamp without time zone,
ADD COLUMN IF NOT EXISTS tetanus2_date timestamp without time zone,
ADD COLUMN IF NOT EXISTS tetanus3_date timestamp without time zone;


ALTER TABLE public.rch_pnc_master
ADD COLUMN IF NOT EXISTS counseling_done BOOLEAN,
ADD COLUMN IF NOT EXISTS next_service_date timestamp without time zone;