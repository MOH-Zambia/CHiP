CREATE TABLE public.notification_type_master
(
  id bigserial,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  code character varying(10),
  name character varying(300),
  type character varying(50),
  role_id bigint,
  state character varying(255),
  CONSTRAINT notification_type_master_pkey PRIMARY KEY (id)
);
INSERT INTO public.notification_type_master(
            id, created_by, created_on, modified_by, modified_on, code, name, 
            type, role_id, state)

 

select id,created_by,created_on,modified_by,modified_on,code,name,type,role_id,state
from notification_master  ;

Drop TABLE if exists notification_master;
Drop TABLE if exists notification_configuration;
Drop TABLE if exists mobile_notification_configuration;
Drop TABLE if exists notification_configuration_type;
