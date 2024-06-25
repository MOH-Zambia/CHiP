DROP TABLE IF EXISTS public.rch_child_cp_suspects;
CREATE TABLE public.rch_child_cp_suspects(
id bigserial,
member_id bigint,
location_id bigint,
CONSTRAINT rch_child_cp_suspects_pkey PRIMARY KEY (id)
);

CREATE INDEX 
   ON public.rch_child_cp_suspects (location_id ASC NULLS LAST);
