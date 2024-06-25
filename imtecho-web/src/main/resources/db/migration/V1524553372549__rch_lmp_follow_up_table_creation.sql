CREATE TABLE if not exists rch_lmp_follow_up
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
  is_pregnant boolean NOT NULL,
  pregnancy_test_done boolean,
  family_planning_method bigint,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT rch_lmp_follow_up_pkey PRIMARY KEY (id)
);