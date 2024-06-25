CREATE TABLE public.rch_wpd_mother_high_risk_rel
(
  wpd_id bigint NOT NULL,
  mother_high_risk bigint NOT NULL,
  CONSTRAINT rch_wpd_mother_high_risk_rel_pkey PRIMARY KEY (wpd_id, mother_high_risk),
  CONSTRAINT rch_wpd_mother_high_risk_rel_wpd_id_fkey FOREIGN KEY (wpd_id)
      REFERENCES public.rch_wpd_mother_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)