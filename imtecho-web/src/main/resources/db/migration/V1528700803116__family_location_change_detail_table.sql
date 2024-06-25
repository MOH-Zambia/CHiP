drop table if exists imt_family_location_change_detail;

CREATE TABLE imt_family_location_change_detail
(
  id bigserial,
  family_id text,
  from_location_id integer,
  to_location_id integer,
  created_on timestamp without time zone,
  created_by bigint,
  CONSTRAINT imt_family_location_change_detail_pkey PRIMARY KEY (id)
);

CREATE OR REPLACE FUNCTION public.imt_family_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	if OLD.location_id != -1 and NEW.location_id<>OLD.location_id then
	insert into imt_family_location_change_detail(family_id,from_location_id,to_location_id,created_on,created_by)
	values(OLD.family_id,OLD.location_id,NEW.location_id,now(),NEW.modified_by);
	end if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE TRIGGER imt_family_update_trigger
  AFTER UPDATE
  ON public.imt_family
  FOR EACH ROW
  EXECUTE PROCEDURE public.imt_family_update_trigger_func();
