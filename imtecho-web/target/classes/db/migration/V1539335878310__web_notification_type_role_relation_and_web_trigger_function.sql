CREATE OR REPLACE FUNCTION public.techo_web_notification_master_insert_trigger_func()
  RETURNS trigger AS
$BODY$BEGIN
	if NEW.notification_type_id is not null and NEW.escalation_level_id is not null then
            NEW.notification_type_escalation_id := CONCAT(NEW.notification_type_id,'_',NEW.escalation_level_id);
        else
	    NEW.notification_type_escalation_id := null;
	end if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

DROP TRIGGER IF EXISTS techo_web_notification_master_before_insert_trigger ON public.techo_web_notification_master;

CREATE TRIGGER techo_web_notification_master_before_insert_trigger
  BEFORE INSERT OR UPDATE
  ON public.techo_web_notification_master
  FOR EACH ROW
  EXECUTE PROCEDURE public.techo_web_notification_master_insert_trigger_func();

ALTER TABLE public.techo_web_notification_master
   ALTER COLUMN escalation_level_id SET NOT NULL;

DROP TABLE IF EXISTS public.notification_type_role_rel;

CREATE TABLE public.notification_type_role_rel
(
  notification_type_id bigint NOT NULL,
  role_id bigint NOT NULL,
  CONSTRAINT notification_type_role_rel_pkey PRIMARY KEY (notification_type_id, role_id)
);

