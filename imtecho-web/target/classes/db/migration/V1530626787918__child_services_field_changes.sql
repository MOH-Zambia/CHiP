ALTER TABLE rch_child_service_master
DROP COLUMN if exists other_death_reason, ADD COLUMN other_death_reason character varying(50);

ALTER TABLE rch_child_service_master
DROP COLUMN if exists complementary_feeding_start_period, ADD COLUMN complementary_feeding_start_period character varying(15);

ALTER TABLE rch_child_service_master
DROP COLUMN if exists other_diseases, ADD COLUMN other_diseases character varying(50);

ALTER TABLE rch_child_service_master
DROP COLUMN if exists mid_arm_circumference, ADD COLUMN mid_arm_circumference real;

ALTER TABLE rch_child_service_master
DROP COLUMN if exists height, ADD COLUMN height integer;

ALTER TABLE rch_child_service_master
DROP COLUMN if exists have_pedal_edema, ADD COLUMN have_pedal_edema boolean;

ALTER TABLE rch_child_service_master
DROP COLUMN if exists exclusively_breastfeded, ADD COLUMN exclusively_breastfeded boolean;

ALTER TABLE rch_wpd_mother_master
DROP COLUMN if exists other_danger_signs, ADD COLUMN other_danger_signs character varying(50);

ALTER TABLE rch_wpd_child_master
DROP COLUMN if exists other_congential_deformity, ADD COLUMN other_congential_deformity character varying(50);

ALTER TABLE rch_wpd_child_master
DROP COLUMN if exists other_congential_deformity, ADD COLUMN other_congential_deformity character varying(50);

ALTER TABLE rch_anc_master
DROP COLUMN if exists other_previous_pregnancy_complication, ADD COLUMN other_previous_pregnancy_complication character varying(50);

DROP TABLE if exists rch_anc_previous_pregnancy_complication_rel;
CREATE TABLE if not exists rch_anc_previous_pregnancy_complication_rel
(
  anc_id bigint NOT NULL,
  previous_pregnancy_complication character varying(15) NOT NULL,
  PRIMARY KEY (anc_id, previous_pregnancy_complication),
  FOREIGN KEY (anc_id)
      REFERENCES rch_anc_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);