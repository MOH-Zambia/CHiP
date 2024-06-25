CREATE TABLE public.rch_wpd_mother_treatment_rel
(
  wpd_id bigint NOT NULL,
  mother_treatment bigint NOT NULL,
  CONSTRAINT rch_wpd_mother_treatment_rel_pkey PRIMARY KEY (wpd_id, mother_treatment),
  CONSTRAINT rch_wpd_mother_treatment_rel_wpd_id_fkey FOREIGN KEY (wpd_id)
      REFERENCES public.rch_wpd_mother_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)