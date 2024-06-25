CREATE OR REPLACE FUNCTION public.location_master_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	if NEW.type <> OLD.type then
	update location_hierchy_closer_det set child_loc_type = NEW.type where child_id = NEW.id;
	end if;

	if OLD.parent is null and NEW.parent is not null then
		INSERT INTO public.location_hierchy_closer_det(
			child_id, child_loc_type, depth, parent_id, parent_loc_type)
		SELECT  c.child_id,c.child_loc_type, p.depth+c.depth+1,p.parent_id,p.parent_loc_type
		FROM location_hierchy_closer_det p, location_hierchy_closer_det c
		WHERE p.child_id = NEW.parent AND c.parent_id = NEW.id;
	end if; 
	if OLD.parent is not null and NEW.parent <> OLD.parent then
		update location_hierchy_closer_det set parent_id = NEW.parent,parent_loc_type = (select type from location_master where id =NEW.parent)
		where id in (select id from location_hierchy_closer_det where child_id in (select child_id from location_hierchy_closer_det where parent_id = NEW.id) and parent_id =OLD.parent);
		
	update location_hierchy_closer_det closer1 set parent_id = closer1.parent_id from location_hierchy_closer_det closer2 
        where closer1.child_id = NEW.id and closer1.depth > 0 and closer2.child_id = new.parent 
        and closer1.depth = closer2.depth+1 and closer1.parent_id <> closer2.parent_id;

        update location_level_hierarchy_master set level1 = loc.level1,
level2 = loc.level2 ,
level3 = loc.level3 ,
level4 = loc.level4 ,
level5 = loc.level5 ,
level6 = loc.level6 ,
level7 = loc.level7 
from (
select closer2.child_id as location_id,
max (case when location_type_master.level = 1 then closer2.parent_id end) as level1,
max (case when location_type_master.level = 2 then closer2.parent_id end) as level2,
max (case when location_type_master.level = 3 then closer2.parent_id end) as level3,
max (case when location_type_master.level = 4 then closer2.parent_id end) as level4,
max (case when location_type_master.level = 5 then closer2.parent_id end) as level5,
max (case when location_type_master.level = 6 then closer2.parent_id end) as level6,
max (case when location_type_master.level = 7 then closer2.parent_id end) as level7
from location_hierchy_closer_det closer1,location_hierchy_closer_det closer2,location_type_master
where closer1.parent_id = 14672 and closer1.child_id = closer2.child_id 
and location_type_master.type = closer2.parent_loc_type
group by closer2.child_id) as loc
where 
loc.location_id = location_level_hierarchy_master.location_id;
END if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;