ALTER TABLE public.event_mobile_notification_pending
  ADD COLUMN ref_code bigint;

ALTER TABLE public.techo_notification_master
  ADD COLUMN ref_code bigint;

ALTER TABLE public.rch_pnc_master
ADD COLUMN pnc_no text;

-- add coloumn for pregnancy_reg_det_id
ALTER TABLE public.rch_immunisation_master
  ADD COLUMN pregnancy_reg_det_id bigint;

drop table if exists rch_member_service_data_sync_detail;
CREATE TABLE public.rch_member_service_data_sync_detail
(
   id bigserial, 
   member_id bigint, 
   location_id bigint,
   created_on timestamp without time zone, 
   original_lmp timestamp without time zone,
   emamta_lmp timestamp without time zone,
   is_pregnant_in_imtecho boolean,
   is_pregnant_in_emamta boolean,
   emamta_dob timestamp without time zone,
   imtecho_dob timestamp without time zone,
   PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
);


ALTER TABLE public.event_configuration_type
  ADD COLUMN query_code text;

DROP TRIGGER techo_notification_master_update_trigger ON public.techo_notification_master;

CREATE TRIGGER techo_notification_master_update_trigger
  AFTER UPDATE
  ON public.techo_notification_master
  FOR EACH ROW
  EXECUTE PROCEDURE public.techo_notification_master_update_trigger_func();
