CREATE TABLE public.location_hierarchy_type
(
  location_id bigint NOT NULL,
  hierarchy_type character varying(2) NOT NULL,
  CONSTRAINT location_hierarchy_type_master_pkey PRIMARY KEY (location_id, hierarchy_type)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.location_hierarchy_type
  OWNER TO postgres;
