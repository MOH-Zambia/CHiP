CREATE TABLE if not exists public.anganwadi_master
(
  id integer NOT NULL DEFAULT nextval('anganwadi_master_id_seq'::regclass),
  created_by character varying(255),
  created_on timestamp without time zone,
  emamta_id character varying(255),
  name character varying(255) NOT NULL,
  parent bigint,
  state character varying(255),
  type character varying(255),
  updated_by character varying(255),
  updated_on timestamp without time zone,
  CONSTRAINT anganwadi_master_pkey PRIMARY KEY (id)
);