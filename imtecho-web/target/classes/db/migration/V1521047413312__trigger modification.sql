CREATE OR REPLACE FUNCTION location_master_update_trigger_func()
  RETURNS trigger AS
$$
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
	END if;
   RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION um_role_master_insert_trigger_func()
  RETURNS trigger AS
$$
BEGIN
	INSERT INTO public.usermanagement_system_role(
            id, name, description, created_by, created_on, modified_by, modified_on, 
            is_active, is_archive, label)
	VALUES (
	NEW.id
	,NEW.name
	,NEW.description
	,(select user_id from usermanagement_system_user where id = NEW.created_by)
	,current_date
	,case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
	,current_date
	,true
	,false
	,NEW.code
	);
   RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER um_role_master_insert_trigger
  AFTER INSERT
  ON um_role_master
  FOR EACH ROW
EXECUTE PROCEDURE um_role_master_insert_trigger_func();


CREATE OR REPLACE FUNCTION um_role_master_update_trigger_func()
  RETURNS trigger AS
$$
BEGIN
	update usermanagement_system_role set name = NEW.name, description =NEW.description 
		,modified_by = case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
		, modified_on = current_date, is_active = case when NEW.state = 'ACTIVE' then true else false end, label = NEW.code where id = NEW.id;
	
   RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER um_role_master_update_trigger
  AFTER UPDATE
  ON um_role_master
  FOR EACH ROW
EXECUTE PROCEDURE um_role_master_update_trigger_func();
