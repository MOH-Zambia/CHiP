DROP TABLE IF EXISTS public.drtecho_unidentified_service_master;
CREATE TABLE public.drtecho_unidentified_service_master
(
  id bigserial,
  user_id bigint,
  first_name text,
  middle_name text,
  last_name text,
  dob date,
  aadhar_number text,
  location_id bigint,
  address text,
  service_type text,
  service_date timestamp without time zone,
  delivery_date timestamp without time zone,
  health_infrastructure_id bigint,
  json_data text,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  CONSTRAINT drtecho_unidentified_service_master_pkey PRIMARY KEY (id)
);