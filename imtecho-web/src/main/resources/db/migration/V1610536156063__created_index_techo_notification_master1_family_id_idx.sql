-- index created for family_id column of techo_notification_master

DROP INDEX if exists techo_notification_master1_family_id_idx;

CREATE INDEX techo_notification_master1_family_id_idx
    ON public.techo_notification_master USING btree (family_id);
