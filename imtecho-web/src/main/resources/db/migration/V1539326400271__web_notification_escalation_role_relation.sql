ALTER TABLE public.notification_type_master
DROP COLUMN IF EXISTS action_on_role_id,  
ADD COLUMN action_on_role_id bigint;

ALTER TABLE public.techo_web_notification_master
DROP COLUMN IF EXISTS notification_type_escalation_id,  
ADD COLUMN notification_type_escalation_id text;

DROP TABLE IF EXISTS public.escalation_level_role_rel;

CREATE TABLE public.escalation_level_role_rel
(
  escalation_level_id bigint NOT NULL,
  role_id bigint NOT NULL,
  CONSTRAINT escalation_level_role_rel_pkey PRIMARY KEY (escalation_level_id, role_id)
);

DROP TABLE IF EXISTS public.escalation_level_user_rel;

CREATE TABLE public.escalation_level_user_rel
(
  escalation_level_id bigint NOT NULL,
  user_id bigint NOT NULL,
  CONSTRAINT escalation_level_user_rel_pkey PRIMARY KEY (escalation_level_id, user_id)
);