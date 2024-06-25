DROP TABLE IF EXISTS public.cm_dashboard_imr_mmr;
CREATE TABLE public.cm_dashboard_imr_mmr( 
location_id bigint,
mother_death bigint,
live_birth bigint,
infant_death bigint,
financial_year varchar(20),
asondt timestamp with time zone,
CONSTRAINT cm_dashboard_imr_mmr_pkey PRIMARY KEY (location_id,financial_year)
);