drop table if exists failed_health_id_data;

CREATE TABLE if not exists failed_health_id_data
(
id bigserial,
  user_id integer,
  family_id text,
  member_id integer UNIQUE,
  name text,
  mobile text,
  aadhar text,
  gender text,
  errorMessage text,
  errorCode integer,
  dob text,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer,
  modified_on timestamp without time zone,
  CONSTRAINT failed_health_id_data_pkey PRIMARY KEY (id)
);