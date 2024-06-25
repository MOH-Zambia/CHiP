-- Function: public.update_location_hierchy_type_master(integer)

-- DROP FUNCTION public.update_location_hierchy_type_master(integer);

CREATE OR REPLACE FUNCTION public.update_location_hierchy_type_master(locationid integer)
  RETURNS integer AS
$BODY$
DECLARE
	corporationCount INT :=0;
	ruralCount INT :=0;
	urbanCount INT :=0;
	r record;
	location_type_temp varchar;
        BEGIN
		DELETE FROM location_hierarchy_type WHERE location_id in (select location_id from
		(SELECT child_id as location_id FROM location_hierchy_closer_det WHERE (parent_id  = locationId)
		 union
		 SELECT parent_id as location_id FROM location_hierchy_closer_det WHERE (child_id = locationId)) lc);

		create TEMPORARY table zzz_type_master_temp(location_type text);
		FOR r IN
			SELECT child_id as location_id FROM location_hierchy_closer_det WHERE (parent_id  = locationId)
			union
			SELECT parent_id as location_id FROM location_hierchy_closer_det WHERE (child_id = locationId)

		LOOP
			truncate table zzz_type_master_temp;
			--DELETE FROM location_hierarchy_type WHERE location_id = r.location_id;
			INSERT INTO zzz_type_master_temp SELECT location_type FROM (SELECT parent_loc_type as location_type from location_hierchy_closer_det
			WHERE (parent_id  = r.location_id or child_id  = r.location_id )
			union
			SELECT child_loc_type as location_type from location_hierchy_closer_det
			WHERE (parent_id  = r.location_id or child_id  = r.location_id)) ta;


			SELECT count(distinct(location_type)) into corporationCount from zzz_type_master_temp where location_type in ('C','Z','U');

			IF corporationCount >=3 THEN
				insert into location_hierarchy_type values (r.location_id,'C');
			END IF;

			SELECT count(distinct(location_type)) into ruralCount from zzz_type_master_temp ts where location_type in ('D','B','P');


			IF ruralCount >=3 THEN
				insert into location_hierarchy_type values (r.location_id, 'R');
			END IF;

			SELECT count(distinct(location_type)) into urbanCount from zzz_type_master_temp ts where location_type in ('D','B','U');

			IF urbanCount >=3 THEN
				insert into location_hierarchy_type values (r.location_id,'U');
			END IF;

		END LOOP;
		drop table zzz_type_master_temp;
                RETURN 1;
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
