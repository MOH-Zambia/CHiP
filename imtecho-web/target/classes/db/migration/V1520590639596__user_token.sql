CREATE TABLE if not exists public.user_token
(
  user_id bigint NOT NULL,
  created_on timestamp without time zone,
  is_active boolean NOT NULL,
  is_archieve boolean NOT NULL,
  modified_on timestamp without time zone,
  user_token character varying(255),
  CONSTRAINT user_token_pkey PRIMARY KEY (user_id)
);