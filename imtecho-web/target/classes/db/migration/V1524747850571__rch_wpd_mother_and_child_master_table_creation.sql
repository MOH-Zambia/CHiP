CREATE TABLE if not exists rch_wpd_mother_master
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
  date_of_delivery timestamp without time zone,
  member_status character varying(100),
  is_preterm_birth boolean,
  delivery_place character varying(100),
  type_of_hospital bigint,
  delivery_done_by character varying(100),
  mother_alive boolean,
  type_of_delivery character varying(100),
  referral_done boolean,
  referral_place bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_wpd_mother_danger_signs_rel
(
  wpd_id bigint NOT NULL,
  mother_danger_signs bigint NOT NULL,
  PRIMARY KEY (wpd_id, mother_danger_signs),
  FOREIGN KEY (wpd_id)
      REFERENCES rch_wpd_mother_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE if not exists rch_wpd_child_master
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
  wpd_mother_id bigint,
  mother_id bigint,
  pregnancy_outcome character varying(100),
  gender character varying(100),
  birth_weight real,
  date_of_delivery timestamp without time zone,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  PRIMARY KEY (id)
);

CREATE TABLE if not exists rch_wpd_child_congential_deformity_rel
(
  wpd_id bigint NOT NULL,
  congential_deformity bigint NOT NULL,
  PRIMARY KEY (wpd_id, congential_deformity),
  FOREIGN KEY (wpd_id)
      REFERENCES rch_wpd_child_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
);