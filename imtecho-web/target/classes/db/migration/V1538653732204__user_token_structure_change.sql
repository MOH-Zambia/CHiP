CREATE TABLE public.user_token_temp
(
  id bigserial,		
  user_id bigint NOT NULL,
  created_on timestamp without time zone,
  is_active boolean NOT NULL,
  is_archieve boolean NOT NULL,
  modified_on timestamp without time zone,
  user_token character varying(255),
  CONSTRAINT user_token_temp_pkey PRIMARY KEY (id)
);

insert into user_token_temp (user_id,created_on,is_active,is_archieve,modified_on,user_token) select user_id,created_on,is_active,is_archieve,modified_on,user_token  from user_token order by user_id;

ALTER TABLE public.user_token RENAME TO user_token_old;

ALTER TABLE public.user_token_temp RENAME TO user_token;