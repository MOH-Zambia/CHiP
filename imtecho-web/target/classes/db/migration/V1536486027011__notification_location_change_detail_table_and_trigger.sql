drop table if exists techo_notification_location_change_detail;
CREATE TABLE techo_notification_location_change_detail
(
  id bigserial primary key,
  notification_id bigint NOT NULL,
  from_location_id integer,
  to_location_id integer,
  created_by bigint NOT NULL,
  created_on timestamp without time zone NOT NULL
);

CREATE OR REPLACE FUNCTION public.techo_notification_master_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN

	IF OLD.state <> NEW.state or OLD.schedule_date <> NEW.schedule_date then

	INSERT INTO public.techo_notification_state_detail(
            notification_id, from_state, to_state, from_schedule_date, 
            to_schedule_date, created_by, created_on, modified_by, modified_on)
        VALUES (NEW.id,OLD.state,NEW.state,OLD.schedule_date,
            NEW.schedule_date, NEW.modified_by, now(), NEW.modified_by, now());
    
	End if;

	if OLD.location_id <> NEW.location_id then

	INSERT INTO public.techo_notification_location_change_detail(
	notification_id , from_location_id , to_location_id , created_by , created_on)
	values(NEW.id,OLD.location_id,NEW.location_id,NEW.modified_by, now());
	
	End if;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;