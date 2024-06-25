DROP TABLE if exists user_form_access;

CREATE TABLE if not exists user_form_access (
  user_id bigint,
  form_code character varying(10) NOT NULL,
  state character varying(255),
  created_on timestamp without time zone,
  CONSTRAINT user_form_pkey PRIMARY KEY (user_id,form_code)
);



--Add column in listvalue_form_master

ALTER TABLE public.listvalue_form_master ADD COLUMN is_training_req boolean default False;

ALTER TABLE public.listvalue_form_master ADD COLUMN query_for_training_completed character varying(255);
