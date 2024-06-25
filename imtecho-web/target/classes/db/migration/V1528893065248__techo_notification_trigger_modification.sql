/*DROP TRIGGER techo_notification_master_update_trigger ON public.techo_notification_master;

CREATE TRIGGER techo_notification_master_update_trigger
 AFTER UPDATE
 ON public.techo_notification_master
 FOR EACH ROW
 EXECUTE PROCEDURE public.techo_notification_master_update_trigger_func();*/