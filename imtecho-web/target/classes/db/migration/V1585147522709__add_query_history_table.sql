DROP TABLE if exists public.query_history;

CREATE TABLE IF NOT EXISTS public.query_history
(
  id serial,
  query text,
  user_id int,
  params character varying(255),
  returns_result_set boolean,
  executed_state character varying(255),
  created_by int NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by int,
  modified_on timestamp without time zone,
  CONSTRAINT query_history_pkey PRIMARY KEY (id)
);