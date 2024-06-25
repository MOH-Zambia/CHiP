DROP TABLE IF EXISTS public.location_mobile_feature_master;
CREATE TABLE public.location_mobile_feature_master(
id bigserial,
location_id bigint,
feature text,
CONSTRAINT location_mobile_feature_master_pkey PRIMARY KEY (id)
);

CREATE INDEX 
   ON public.location_mobile_feature_master (location_id ASC NULLS LAST);