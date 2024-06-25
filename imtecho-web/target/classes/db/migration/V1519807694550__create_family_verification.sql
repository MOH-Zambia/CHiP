DROP TABLE if exists imt_family_verification;

CREATE TABLE if not exists imt_family_verification (
  id bigserial,
  family_id character varying(255),
  location_id bigint,
  schedule_date timestamp without time zone,
  head character varying(255),
  mobile_number character varying(20),
  call_attempt integer DEFAULT 0,
  created_by bigint,
  created_on timestamp without time zone,
  gvk_state character varying(255),
  state character varying(255),
  type character varying(255),
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT imt_family_verification_pkey PRIMARY KEY (id)
);
