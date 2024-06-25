CREATE OR REPLACE FUNCTION update_location_hierchy_location_type_master(locationid integer)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
	corporationCount INT :=0;
	ruralCount INT :=0;
	urbanCount INT :=0;
	hierarchy_type_string varchar(3) := '';
	r record;
        BEGIN
            create TEMPORARY table zzz_type_master_temp(location_type text);
            FOR r IN
                SELECT child_id as location_id FROM location_hierchy_closer_det WHERE (parent_id  = locationid)
                union
                SELECT parent_id as location_id FROM location_hierchy_closer_det WHERE (child_id = locationid and parent_id not in (-1, -2))

            LOOP
                truncate table zzz_type_master_temp;
                hierarchy_type_string := '';
                --DELETE FROM location_hierarchy_type WHERE location_id = r.location_id;
                INSERT INTO zzz_type_master_temp SELECT location_type FROM (
                SELECT parent_loc_type as location_type from location_hierchy_closer_det
                WHERE (child_id  = r.location_id )
                union
                SELECT child_loc_type as location_type from location_hierchy_closer_det
                WHERE (parent_id  = r.location_id)) ta;


                SELECT count(distinct(location_type)) into corporationCount from zzz_type_master_temp where location_type in ('C','Z','U');

                IF corporationCount >=3 THEN
                    hierarchy_type_string := 'C';
                END IF;

                SELECT count(distinct(location_type)) into ruralCount from zzz_type_master_temp ts where location_type in ('D','B','P');


                IF ruralCount >=3 THEN
                    hierarchy_type_string := concat(hierarchy_type_string,'R');
                END IF;

                SELECT count(distinct(location_type)) into urbanCount from zzz_type_master_temp ts where location_type in ('D','B','U');

                IF urbanCount >=3 THEN
                    hierarchy_type_string := concat(hierarchy_type_string,'U');
                END IF;

                update location_master set demographic_type = hierarchy_type_string
                where id = r.location_id and (demographic_type is null or demographic_type != hierarchy_type_string);

                update location_hierchy_closer_det set child_loc_demographic_type = hierarchy_type_string
                where child_id = r.location_id and (child_loc_demographic_type is null or child_loc_demographic_type != hierarchy_type_string);

                update location_hierchy_closer_det set parent_loc_demographic_type = hierarchy_type_string
                where parent_id = r.location_id and (parent_loc_demographic_type is null or parent_loc_demographic_type != hierarchy_type_string);

            END LOOP;
            drop table zzz_type_master_temp;
            RETURN 1;
        END;
$function$
;
