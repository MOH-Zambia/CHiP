CREATE TABLE public.query_analytics
(
  id bigserial,
  execution_time bigint,
  query text,
  CONSTRAINT query_analytics_pkey PRIMARY KEY (id)
);
CREATE TABLE public.query_master
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  code character varying(20),
  params character varying(255),
  query text,
  returns_result_set boolean,
  state character varying(255),
  CONSTRAINT query_master_pkey PRIMARY KEY (id)
);

