CREATE TABLE if not exists public.system_sync_status
(
  id character varying(255) NOT NULL,
  action_date timestamp without time zone NOT NULL,
  relative_id bigint,
  status character varying(255),
  record_string character varying(10000),
  mobile_date timestamp without time zone,
  user_id bigint,
  device character varying(255),
  client_id bigint,
  lastmodified_by bigint,
  lastmodified_date timestamp without time zone,
  duration_of_processing bigint,
  CONSTRAINT system_sync_status_pkey PRIMARY KEY (id)
);