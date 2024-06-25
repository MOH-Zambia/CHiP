DROP TABLE IF EXISTS public.techo_web_notification_master;
CREATE TABLE public.techo_web_notification_master
(
  id bigserial,
  notification_type_id bigint NOT NULL,
  location_id bigint,
  location_hierarchy_id bigint,
  user_id bigint,
  family_id bigint,
  member_id bigint,
  escalation_level_id bigint,
  schedule_date timestamp without time zone NOT NULL,
  due_on timestamp without time zone,
  expiry_date timestamp without time zone,
  action_by bigint,
  state character varying(100),
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,
  ref_code bigint,
  other_details text,
  
  CONSTRAINT techo_web_notification_master_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS public.escalation_level_master;

CREATE TABLE public.escalation_level_master
(
  id bigserial,
  name text,
  notification_type_id bigint NOT NULL,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by bigint,
  modified_on timestamp without time zone,

  CONSTRAINT escalation_level_master_pkey PRIMARY KEY (id)	
);

ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS data_query_id;

ALTER TABLE public.notification_type_master
   ADD COLUMN data_query_id bigint;

ALTER TABLE public.notification_type_master
  DROP COLUMN IF EXISTS action_query_id;

ALTER TABLE public.notification_type_master
   ADD COLUMN action_query_id bigint;