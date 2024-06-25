DROP TABLE IF EXISTS public.mytecho_user;

CREATE TABLE public.mytecho_user
(
  id bigint NOT NULL DEFAULT nextval('um_user_id_seq'::regclass),
  user_name text NOT NULL,
  first_name text NOT NULL,
  middle_name text,
  last_name text NOT NULL,
  mobile_number text NOT NULL,
  password text,
  pin text,
  state text,
  language_preference character varying(5) NOT NULL,
  gender character varying(1),
  dob date,
  address text,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT mytecho_user_pkey PRIMARY KEY (id)
)