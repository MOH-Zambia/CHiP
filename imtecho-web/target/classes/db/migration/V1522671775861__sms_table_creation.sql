CREATE TABLE if not exists public.sms
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  mobile_numbers character varying,
  message character varying,
  response character varying,
  CONSTRAINT sms_pkey PRIMARY KEY (id)
);

