CREATE TABLE if not exists rch_anc_master
(
  id bigserial,
  member_id bigint NOT NULL,
  family_id bigint NOT NULL,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  location_id bigint NOT NULL,
  location_hierarchy_id bigint NOT NULL,
  lmp timestamp without time zone,
  weight real,
  jsy_beneficiary boolean,
  kpsy_beneficiary boolean,
  iay_beneficiary boolean,
  chiranjeevi_yojna_beneficiary boolean,
  anc_place bigint,
  haemoglobin_count integer,
  systolic_bp integer,
  diastolic_bp integer,
  member_height integer,
  foetal_movement boolean,
  foetal_height integer,
  foetal_heart_sound boolean,
  foetal_position bigint,
  ifa_tablets_given integer,
  fa_tablets_given integer,
  calcium_tablets_given integer,
  hbsag_test char varying(30),
  blood_sugar_test char varying(30),
  blood_sugar_test_value integer,
  urine_test_done boolean,
  urine_albumin integer,
  urine_sugar integer,
  albendazole_given boolean,
  referral_done boolean,
  referral_place bigint,
  dead_flag boolean,
  other_dangerous_sign char varying(500),
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_anc_dangerous_sign_rel
(
  anc_id bigint NOT NULL,
  dangerous_sign_id bigint NOT NULL,
  PRIMARY KEY (anc_id, dangerous_sign_id),
  FOREIGN KEY (anc_id)
      REFERENCES rch_anc_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);