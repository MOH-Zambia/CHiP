ALTER TABLE public.imt_member
    ADD COLUMN year_of_wedding character varying(10);

ALTER TABLE public.rch_lmp_follow_up
    ADD COLUMN year_of_wedding character varying(10);

ALTER TABLE public.rch_lmp_follow_up
    ADD COLUMN register_now_for_pregnancy boolean;

ALTER TABLE public.rch_anc_master
    ADD COLUMN member_status character varying(100);

ALTER TABLE public.rch_anc_master
    ADD COLUMN edd timestamp without time zone;

ALTER TABLE public.rch_wpd_mother_master
    ADD COLUMN discharge_date timestamp without time zone;

ALTER TABLE public.rch_wpd_mother_master
    ADD COLUMN breast_feeding_in_one_hour boolean;

ALTER TABLE public.rch_wpd_child_master
    ADD COLUMN baby_cried_at_birth boolean;



CREATE TABLE if not exists rch_anc_death_reason_rel
(
  anc_id bigint NOT NULL,
  death_reason bigint NOT NULL,
  PRIMARY KEY (anc_id, death_reason),
  FOREIGN KEY (anc_id)
      REFERENCES rch_anc_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE if not exists rch_wpd_mother_death_reason_rel
(
  wpd_id bigint NOT NULL,
  mother_death_reason bigint NOT NULL,
  PRIMARY KEY (wpd_id, mother_death_reason),
  FOREIGN KEY (wpd_id)
      REFERENCES rch_wpd_mother_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);