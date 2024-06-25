-- Query to retrieve location type by level.
DELETE FROM QUERY_MASTER WHERE CODE='retrive_location_type_by_level';

INSERT INTO public.QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state ) 
VALUES ( 
'0bf19776-f0d3-471e-867a-a174826f6aea', -1,  current_date , -1,  current_date , 'retrive_location_type_by_level', 
'level', 
'select * from location_type_master where level=#level#', 
'Retrive location type by level', 
true, 'ACTIVE');


-- Added logic to check if location type is changed then update location type in location_hierchy_closer_det, location_level_hierarchy_maste 
CREATE OR REPLACE FUNCTION public.location_master_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	if NEW.type <> OLD.type then
	update location_hierchy_closer_det set child_loc_type = NEW.type where child_id = NEW.id;
	update location_hierchy_closer_det set parent_loc_type = NEW.type where parent_id = NEW.id;
	update location_level_hierarchy_master set location_type = NEW.type where location_id = NEW.id;
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
		
	update location_hierchy_closer_det closer1 set parent_id = closer2.parent_id from location_hierchy_closer_det closer2 
        where closer1.child_id = NEW.id and closer1.depth > 0 and closer2.child_id = new.parent 
        and closer1.depth = closer2.depth+1 and closer1.parent_id <> closer2.parent_id
        and closer1.parent_id != -1 and closer2.parent_id != -1;

        update location_level_hierarchy_master set level1 = loc.level1,
level2 = loc.level2 ,
level3 = loc.level3 ,
level4 = loc.level4 ,
level5 = loc.level5 ,
level6 = loc.level6 ,
level7 = loc.level7 ,
level8 = loc.level8 
from (
select closer2.child_id as location_id,
max (case when location_type_master.level = 1 then closer2.parent_id end) as level1,
max (case when location_type_master.level = 2 then closer2.parent_id end) as level2,
max (case when location_type_master.level = 3 then closer2.parent_id end) as level3,
max (case when location_type_master.level = 4 then closer2.parent_id end) as level4,
max (case when location_type_master.level = 5 then closer2.parent_id end) as level5,
max (case when location_type_master.level = 6 then closer2.parent_id end) as level6,
max (case when location_type_master.level = 7 then closer2.parent_id end) as level7,
max (case when location_type_master.level = 8 then closer2.parent_id end) as level8
from location_hierchy_closer_det closer1,location_hierchy_closer_det closer2,location_type_master
where closer1.parent_id = NEW.id and closer1.child_id = closer2.child_id 
and location_type_master.type = closer2.parent_loc_type
group by closer2.child_id) as loc
where 
loc.location_id = location_level_hierarchy_master.location_id;



END if;


if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE location_master
		SET created_by='|| quote_nullable(NEW.created_by) || ', created_on='|| quote_nullable(NEW.created_on) || ', 
		modified_by='|| quote_nullable(NEW.modified_by) || ', modified_on='|| quote_nullable(NEW.modified_on) || ', 
		address='|| quote_nullable(NEW.address) || ', associated_user='|| quote_nullable(NEW.associated_user) || ', 
		contact1_email='|| quote_nullable(NEW.contact1_email) || ', contact1_name='|| quote_nullable(NEW.contact1_name) || ', 
	        contact1_phone='|| quote_nullable(NEW.contact1_phone) || ', contact2_email='|| quote_nullable(NEW.contact2_email) || ', 
	        contact2_name='|| quote_nullable(NEW.contact2_name) || ', 
	        contact2_phone='|| quote_nullable(NEW.contact2_phone) || ', is_active='|| quote_nullable(NEW.is_active) || ', 
	        is_archive='|| quote_nullable(NEW.is_archive) || ', max_users='|| quote_nullable(NEW.max_users) || ', 
	        name='|| quote_nullable(NEW.name) || ',english_name='|| quote_nullable(NEW.english_name) || ', pin_code='|| quote_nullable(NEW.pin_code) || ', 
	        type='|| quote_nullable(NEW.type) || ', unique_id='|| quote_nullable(NEW.unique_id) || ', 
	        parent='|| quote_nullable(NEW.parent) || ', is_tba_avaiable='|| quote_nullable(NEW.is_tba_avaiable) || ', 
	        total_population='|| quote_nullable(NEW.total_population) || ', location_hierarchy_id='|| quote_nullable(NEW.location_hierarchy_id) || ', 
	        location_code='|| quote_nullable(NEW.location_code) || ', state='|| quote_nullable(NEW.state) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'

        ); 
	end if;

	if old.type='SC' or old.type='P' then
			update rch_institution_master set name=new.name where location_id=old.id and is_location = true;
	end if;
if NEW.type in ('A','AA') and NEW.parent!=OLD.parent then
	update imt_family set location_id = NEW.parent,modified_on = now() where area_id = NEW.id;
end if;	
	
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;