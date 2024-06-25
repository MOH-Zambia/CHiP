CREATE TABLE if not exists public.role_management
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  role_id bigint,
  managed_by_user_id bigint,
  managed_by_role_id bigint,
  state character varying (255),
  CONSTRAINT role_management_pkey PRIMARY KEY (id),

  CONSTRAINT fk_role_master_id_um_role_management_managed_role_id FOREIGN KEY (role_id)
      REFERENCES public.um_role_master (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
  
);
CREATE TABLE if not exists public.role_hierarchy_management
(
  id bigserial NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  role_id bigint,
  user_id bigint,
  location_type character varying(255),
  hierarchy_id bigint,
  state character varying (255),


  CONSTRAINT role_hierarchy_management_pkey PRIMARY KEY (id)

  
);

