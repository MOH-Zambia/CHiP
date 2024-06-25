CREATE TABLE public.report_query_master
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  params character varying(255),
  query text,
  returns_result_set boolean,
  state character varying(255),
  CONSTRAINT report_query_master_pkey PRIMARY KEY (id)
);
