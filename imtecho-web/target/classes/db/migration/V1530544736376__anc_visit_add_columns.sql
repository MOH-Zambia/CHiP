ALTER TABLE rch_anc_master
DROP COLUMN if exists jsy_payment_done, ADD COLUMN jsy_payment_done boolean;

ALTER TABLE rch_anc_master
DROP COLUMN if exists last_delivery_outcome, ADD COLUMN last_delivery_outcome character varying(50);

ALTER TABLE rch_anc_master
DROP COLUMN if exists expected_delivery_place, ADD COLUMN expected_delivery_place character varying(50);

CREATE TABLE if not exists rch_anc_previous_pregnancy_complication_rel
(
  anc_id bigint NOT NULL,
  previous_pregnancy_complication bigint NOT NULL,
  PRIMARY KEY (anc_id, previous_pregnancy_complication),
  FOREIGN KEY (anc_id)
      REFERENCES rch_anc_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_anc_family_planning_method_rel
(
  anc_id bigint NOT NULL,
  family_planning_method bigint NOT NULL,
  PRIMARY KEY (anc_id, family_planning_method),
  FOREIGN KEY (anc_id)
      REFERENCES rch_anc_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);