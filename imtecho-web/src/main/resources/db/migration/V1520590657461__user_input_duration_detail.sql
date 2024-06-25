CREATE TABLE if not exists public.user_input_duration_detail
(
  id bigint NOT NULL DEFAULT nextval('user_input_duration_detail_id_seq'::regclass),
  by_user bigint NOT NULL,
  duration bigint NOT NULL,
  form_type character varying(15) NOT NULL,
  is_active boolean NOT NULL,
  on_date date NOT NULL,
  related_id bigint NOT NULL,
  beneficiaryid bigint,
  is_child boolean,
  mobile_created_on_date timestamp without time zone,
  form_start_date timestamp without time zone,
  CONSTRAINT user_input_duration_detail_pkey PRIMARY KEY (id)
);