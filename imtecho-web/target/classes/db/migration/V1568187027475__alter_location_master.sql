ALTER TABLE public.location_master RENAME hierarchy_type  TO demographic_type;

ALTER TABLE public.location_hierchy_closer_det RENAME child_loc_hierarchy_type  TO child_loc_demographic_type;
 
ALTER TABLE public.location_hierchy_closer_det RENAME parent_loc_hierarchy_type  TO parent_loc_demographic_type;

DROP TABLE if exists location_demographic_type_master;

CREATE TABLE location_demographic_type_master
(
  hierarchy_code text NOT NULL,
  hierarchy_type text NOT NULL,
  CONSTRAINT location_hierarchy_type_master_pkey1 PRIMARY KEY (hierarchy_code, hierarchy_type)
);

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('C','U');

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('CRU','R');

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('CRU','U');

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('R','R');

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('RU','R');

INSERT INTO public.location_demographic_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('RU','U');

INSERT INTO public.location_hierarchy_type_master(
            hierarchy_code, hierarchy_type)
VALUES ('U','U');
