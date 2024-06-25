CREATE TABLE if not exists public.notification_master
(
  id bigserial NOT NULL,
  name character varying(300),
  code character varying(10),
  role_id bigint,
  type character varying(50),
  state character varying(255),
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT notification_master_pkey PRIMARY KEY (id)
);