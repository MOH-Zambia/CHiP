CREATE TABLE public.form_master
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  code character varying(20) NOT NULL,
  name character varying(255) NOT NULL,
  state character varying(255),
  CONSTRAINT form_master_pkey PRIMARY KEY (id)
)