DROP TABLE IF EXISTS public.user_health_infrastructure;
CREATE TABLE public.user_health_infrastructure
(
   id bigserial, 
   user_id bigint, 
   health_infrastrucutre_id bigint, 
   created_by bigint, 
   created_on timestamp without time zone, 
   modified_by bigint, 
   modified_on timestamp without time zone, 
   state character varying(200),
   CONSTRAINT pkey_health_infra_user_id PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
)
;
