CREATE TABLE public.rch_wpd_child_danger_signs_rel
(
  wpd_id bigint NOT NULL,
  danger_signs bigint NOT NULL,
  CONSTRAINT rch_wpd_child_danger_signs_rel_pkey PRIMARY KEY (wpd_id, danger_signs),
  CONSTRAINT rch_wpd_child_danger_signs_rel_wpd_id_fkey FOREIGN KEY (wpd_id)
      REFERENCES public.rch_wpd_child_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)