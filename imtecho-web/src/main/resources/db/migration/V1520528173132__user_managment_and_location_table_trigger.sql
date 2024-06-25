
CREATE OR REPLACE FUNCTION um_user_insert_trigger_func()
  RETURNS trigger AS
$$
BEGIN
         INSERT INTO usermanagement_system_user(id,
            user_id, password, type, created_by, created_on, modified_by, 
            modified_on,  is_active, is_archive,  
            custom2)
	 VALUES(NEW.id,NEW.user_name,NEW.password,'ROLE_ADMIN',(select user_id from usermanagement_system_user where id = NEW.created_by)
	,current_date
	 ,case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
	 ,current_date
	 ,true
	 ,false
	 ,NEW.prefered_language
	 );


	INSERT INTO usermanagement_user_contact(
		first_name,
		last_name,
		email_address, 
		mobile_number, 
		address,  
		date_of_birth, 
		gender, 
		userobj, 
		timezone, 
		created_by, 
		created_on, modified_by, modified_on, 
            is_active, is_archive, display_name,  custom1, 
            address2)
	VALUES (NEW.first_name
	,NEW.last_name
	,NEW.email_id
	,NEW.contact_number
	,NEW.address
	,NEW.date_of_birth
	,NEW.gender
	,NEW.id
	,'IST'
	,(select user_id from usermanagement_system_user where id = NEW.created_by)
	,current_date
	,case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
	,current_date
	,true
	,false
	,(NEW.first_name || ' ' || NEW.last_name)
	,-1
	,NEW.user_name);


	update usermanagement_system_user set contact = (select id from usermanagement_user_contact where userobj = NEW.id) where id = NEW.id;
	
	INSERT INTO public.usermanagement_user_role(
            userobj, role, is_active, is_archive)
	VALUES (NEW.id, NEW.role_id, true, false);
 
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER um_user_insert_trigger
  AFTER INSERT
  ON um_user
  FOR EACH ROW
EXECUTE PROCEDURE um_user_insert_trigger_func();



CREATE OR REPLACE FUNCTION um_user_location_insert_trigger_func()
  RETURNS trigger AS
$$
BEGIN

	INSERT INTO public.user_location_detail(
            id, is_active, location_type, location, user_id)
	VALUES (NEW.id, case when NEW.state = 'ACTIVE' then true else false end, NEW.type, new.loc_id, NEW.user_id);


    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';




CREATE TRIGGER um_user_location_insert_trigger
  AFTER INSERT
  ON um_user_location
  FOR EACH ROW
EXECUTE PROCEDURE um_user_location_insert_trigger_func();


CREATE OR REPLACE FUNCTION um_user_update_trigger_func()
  RETURNS trigger AS
$$
BEGIN

	update usermanagement_system_user set user_id = NEW.user_name
	,password = NEW.password
	,modified_by = case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
	,modified_on = current_date
	,is_active = case when NEW.state = 'ACTIVE' then true else false end
	,custom2 = NEW.prefered_language
	where id = NEW.id;
         
	update usermanagement_user_contact set first_name = NEW.first_name
	,last_name = NEW.last_name
	,email_address = NEW.email_id
	,mobile_number = NEW.contact_number
	,address = NEW.address
	,gender = NEW.gender
	,modified_by = case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
	,modified_on = current_date
	,is_active = case when NEW.state = 'ACTIVE' then true else false end
	,display_name = (NEW.first_name || ' ' || NEW.last_name)
	,address2 = NEW.user_name
	where userobj = NEW.id;
	
	update usermanagement_user_role set  role = NEW.role_id,is_active = case when NEW.state = 'ACTIVE' then true else false end
	where userobj = NEW.id;
	
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';


CREATE TRIGGER um_user_update_trigger
  AFTER UPDATE
  ON um_user
  FOR EACH ROW
EXECUTE PROCEDURE um_user_update_trigger_func();




CREATE OR REPLACE FUNCTION um_user_location_update_trigger_func()
  RETURNS trigger AS
$$
BEGIN
	update user_location_detail 
	set is_active = case when NEW.state = 'ACTIVE' then true else false end , location_type = NEW.type,location = new.loc_id,user_id = NEW.user_id
	where id = NEW.id;
	
    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER um_user_location_update_trigger
  AFTER UPDATE
  ON um_user_location
  FOR EACH ROW
EXECUTE PROCEDURE um_user_location_update_trigger_func();


CREATE OR REPLACE FUNCTION location_master_insert_trigger_func()
  RETURNS trigger AS
$$
BEGIN

	INSERT INTO public.location_hierchy_closer_det(
            child_id, child_loc_type, depth, parent_id, parent_loc_type)
    VALUES ( NEW.id, NEW.type, 0, NEW.id, NEW.type);

	if NEW.parent is not null then
		INSERT INTO public.location_hierchy_closer_det(
            child_id, child_loc_type, depth, parent_id, parent_loc_type)
		SELECT  c.child_id,c.child_loc_type, p.depth+c.depth+1,p.parent_id,p.parent_loc_type
		FROM location_hierchy_closer_det p, location_hierchy_closer_det c
		WHERE p.child_id = NEW.parent AND c.parent_id = NEW.id;
	END if;

    RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';




CREATE TRIGGER location_master_insert_trigger
  AFTER INSERT
  ON location_master
  FOR EACH ROW
EXECUTE PROCEDURE location_master_insert_trigger_func();


CREATE OR REPLACE FUNCTION location_master_update_trigger_func()
  RETURNS trigger AS
$$
BEGIN

	update location_hierchy_closer_det set child_loc_type = NEW.type where child_id = NEW.id;

	if NEW.parent <> OLD.parent then
		update location_hierchy_closer_det set parent_id = NEW.parent,parent_loc_type = (select type from location_master where id =NEW.parent)
		where id in (select id from location_hierchy_closer_det where child_id in (select child_id from location_hierchy_closer_det where parent_id = NEW.id) and parent_id =OLD.parent);
	END if;
   RETURN NEW;
END;
$$
LANGUAGE 'plpgsql';



CREATE TRIGGER location_master_update_trigger
  AFTER UPDATE
  ON location_master
  FOR EACH ROW
EXECUTE PROCEDURE location_master_update_trigger_func();
