
CREATE OR REPLACE FUNCTION public.um_user_insert_trigger_func()
  RETURNS trigger AS
$BODY$
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

	if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
	   'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
	   'DROP EXTENSION IF EXISTS dblink;
	    CREATE EXTENSION dblink; 

	    INSERT INTO um_user(
            id, created_by, created_on, first_name, 
            gender, last_name, middle_name, password, prefered_language, 
            role_id, state, user_name, search_text, server_type)
	       Values ('|| quote_nullable(NEW.id) || '
			, '||quote_nullable(NEW.created_by) ||'
			, '||quote_nullable(NEW.created_on) ||'
			, '||quote_nullable(NEW.first_name) ||'
			, '||quote_nullable(NEW.gender) ||'
			, '||quote_nullable(NEW.last_name) ||'
			, '||quote_nullable(NEW.middle_name) ||'
			, '||quote_nullable(NEW.password) ||'
			, '||quote_nullable(NEW.prefered_language) ||'
			, '||quote_nullable(NEW.role_id) ||'
			, '||quote_nullable(NEW.state) ||'
			, '||quote_nullable(NEW.user_name || '_t') ||'
			, '||quote_nullable(NEW.search_text) ||'
			, '||quote_nullable(NEW.server_type) ||');'
	);
	end if;
 
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE OR REPLACE FUNCTION public.um_user_update_trigger_func()
  RETURNS trigger AS
$BODY$
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

	if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_user SET created_by='||quote_nullable(NEW.created_by)||', created_on='||quote_nullable(NEW.created_on)||', 
			modified_by='||quote_nullable(NEW.modified_by)||', modified_on='||quote_nullable(NEW.modified_on)||', 
			aadhar_number='||quote_nullable(NEW.aadhar_number)||', address='||quote_nullable(NEW.address)||', 
			code='||quote_nullable(NEW.code)||', contact_number='||quote_nullable(NEW.contact_number)||', 
			date_of_birth='||quote_nullable(NEW.date_of_birth)||', email_id='||quote_nullable(NEW.email_id)||', 
			first_name='||quote_nullable(NEW.first_name)||', gender='||quote_nullable(NEW.gender)||', 
			last_name='||quote_nullable(NEW.last_name)||', middle_name='||quote_nullable(NEW.middle_name)||', 
			password='||quote_nullable(NEW.password)||', prefered_language='||quote_nullable(NEW.prefered_language)||', 
			role_id='||quote_nullable(NEW.role_id)||', state='||quote_nullable(NEW.state)||', 
			user_name='||quote_nullable(NEW.user_name || '_t')||', search_text='||quote_nullable(NEW.search_text)||', 
			server_type='||quote_nullable(NEW.server_type)||', title='||quote_nullable(NEW.title)||', 
			imei_number='||quote_nullable(NEW.imei_number)||', techo_phone_number='||quote_nullable(NEW.techo_phone_number)||'
			WHERE id='||quote_nullable(NEW.id)||';'
	   
	); 
	end if;
	
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION public.um_role_master_insert_trigger_func()
  RETURNS trigger AS
$BODY$
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

if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
                  'INSERT INTO public.um_role_master(
		created_by, created_on, modified_by, modified_on, code, description, 
		name, state, max_position, is_email_mandatory, is_contact_num_mandatory, 
		is_aadhar_num_mandatory)
		VALUES ('|| quote_nullable(NEW.created_by) || ',
			'|| quote_nullable(NEW.created_on) || ',
			'|| quote_nullable(NEW.modified_by) || ',
			'|| quote_nullable(NEW.modified_on) || ',
			'|| quote_nullable(NEW.code) || ',
			'|| quote_nullable(NEW.description) || ',
			'|| quote_nullable(NEW.name) || ',
			'|| quote_nullable(NEW.state) || ',
			'|| quote_nullable(NEW.max_position) || ',
			'|| quote_nullable(NEW.is_email_mandatory) || ',
			'|| quote_nullable(NEW.is_contact_num_mandatory) || ',
			'|| quote_nullable(NEW.is_aadhar_num_mandatory) || ');'

        ); 
	end if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION public.um_role_master_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	update usermanagement_system_role set name = NEW.name, description =NEW.description 
		,modified_by = case when NEW.modified_by is not null then (select user_id from usermanagement_system_user where id = NEW.modified_by) else null end
		, modified_on = current_date, is_active = case when NEW.state = 'ACTIVE' then true else false end, label = NEW.code where id = NEW.id;


if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_role_master
		SET created_by='|| quote_nullable(NEW.created_by) || ', created_on='|| quote_nullable(NEW.created_on) || ', 
		modified_by='|| quote_nullable(NEW.modified_by) || ', modified_on='|| quote_nullable(NEW.modified_on) || ', 
		code='|| quote_nullable(NEW.code) || ', description='|| quote_nullable(NEW.description) || ', 
		name='|| quote_nullable(NEW.name) || ', state='|| quote_nullable(NEW.state) || ', 
		max_position='|| quote_nullable(NEW.max_position) || ', is_email_mandatory='|| quote_nullable(NEW.is_email_mandatory) || ', 
		is_contact_num_mandatory='|| quote_nullable(NEW.is_contact_num_mandatory) || ', 
		is_aadhar_num_mandatory='|| quote_nullable(NEW.is_aadhar_num_mandatory) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'	
        ); 
	end if;
	
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE OR REPLACE FUNCTION public.location_master_insert_trigger_func()
  RETURNS trigger AS
$BODY$
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
	
	insert into location_wise_analytics (loc_id)
	VALUES (NEW.id);

if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		 'INSERT INTO location_master(
            id, address, associated_user, contact1_email, contact1_name, 
            contact1_phone, contact2_email, contact2_name, contact2_phone, 
            created_by, created_on, is_active, is_archive, max_users, modified_by, 
            modified_on, name, pin_code, type, unique_id, parent, is_tba_avaiable, 
            total_population, location_hierarchy_id, location_code, state)
	       Values ('|| quote_nullable(NEW.id) || '
			, '||quote_nullable(NEW.address) ||'
			, '||quote_nullable(NEW.associated_user) ||'
			, '||quote_nullable(NEW.contact1_email) ||'
			, '||quote_nullable(NEW.contact1_name) ||'
			, '||quote_nullable(NEW.contact1_phone) ||'
			, '||quote_nullable(NEW.contact2_email) ||'
			, '||quote_nullable(NEW.contact2_name) ||'
			, '||quote_nullable(NEW.contact2_phone) ||'
			, '||quote_nullable(NEW.created_by) ||'
			, '||quote_nullable(NEW.created_on) ||'
			, '||quote_nullable(NEW.is_active) ||'
			, '||quote_nullable(NEW.is_archive) ||'
			, '||quote_nullable(NEW.max_users) ||'
			, '||quote_nullable(NEW.modified_by) ||'
			, '||quote_nullable(NEW.modified_on) ||'
			, '||quote_nullable(NEW.name) ||'
			, '||quote_nullable(NEW.pin_code) ||'
			, '||quote_nullable(NEW.type) ||'
			, '||quote_nullable(NEW.unique_id) ||'
			, '||quote_nullable(NEW.parent) ||'
			, '||quote_nullable(NEW.is_tba_avaiable) ||'
			, '||quote_nullable(NEW.total_population) ||'
			, '||quote_nullable(NEW.location_hierarchy_id) ||'
			, '||quote_nullable(NEW.location_code) ||'
			, '||quote_nullable(NEW.state) ||');'
        ); 
	end if;
    
	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

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


if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE location_master
		SET created_by='|| quote_nullable(NEW.created_by) || ', created_on='|| quote_nullable(NEW.created_on) || ', 
		modified_by='|| quote_nullable(NEW.modified_by) || ', modified_on='|| quote_nullable(NEW.modified_on) || ', 
		address='|| quote_nullable(NEW.address) || ', associated_user='|| quote_nullable(NEW.associated_user) || ', 
		contact1_email='|| quote_nullable(NEW.contact1_email) || ', contact1_name='|| quote_nullable(NEW.contact1_name) || ', 
	        contact1_phone='|| quote_nullable(NEW.contact1_phone) || ', contact2_email='|| quote_nullable(NEW.contact2_email) || ', 
	        contact2_name='|| quote_nullable(NEW.contact2_name) || ', 
	        contact2_phone='|| quote_nullable(NEW.contact2_phone) || ', is_active='|| quote_nullable(NEW.is_active) || ', 
	        is_archive='|| quote_nullable(NEW.is_archive) || ', max_users='|| quote_nullable(NEW.max_users) || ', 
	        name='|| quote_nullable(NEW.name) || ', pin_code='|| quote_nullable(NEW.pin_code) || ', 
	        type='|| quote_nullable(NEW.type) || ', unique_id='|| quote_nullable(NEW.unique_id) || ', 
	        parent='|| quote_nullable(NEW.parent) || ', is_tba_avaiable='|| quote_nullable(NEW.is_tba_avaiable) || ', 
	        total_population='|| quote_nullable(NEW.total_population) || ', location_hierarchy_id='|| quote_nullable(NEW.location_hierarchy_id) || ', 
	        location_code='|| quote_nullable(NEW.location_code) || ', state='|| quote_nullable(NEW.state) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'

        ); 
	end if;
   RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

CREATE OR REPLACE FUNCTION public.location_level_hierarchy_master_insert_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		 'INSERT INTO location_level_hierarchy_master(
            id, location_id, level1, level2, level3, level4, level5, level6, 
            level7, effective_date, expiration_date, is_active, location_type)
	       Values ('|| quote_nullable(NEW.id) || '
			, '||quote_nullable(NEW.location_id) ||'
			, '||quote_nullable(NEW.level1) ||'
			, '||quote_nullable(NEW.level2) ||'
			, '||quote_nullable(NEW.level3) ||'
			, '||quote_nullable(NEW.level4) ||'
			, '||quote_nullable(NEW.level5) ||'
			, '||quote_nullable(NEW.level6) ||'
			, '||quote_nullable(NEW.level7) ||'
			, '||quote_nullable(NEW.effective_date) ||'
			, '||quote_nullable(NEW.expiration_date) ||'
			, '||quote_nullable(NEW.is_active) ||'
			, '||quote_nullable(NEW.location_type) ||');'

        ); 
end if;

	RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


CREATE TRIGGER location_level_hierarchy_master_insert_trigger
  AFTER INSERT
  ON public.location_level_hierarchy_master
  FOR EACH ROW
  EXECUTE PROCEDURE public.location_level_hierarchy_master_insert_trigger_func();



CREATE OR REPLACE FUNCTION public.um_user_location_insert_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN

	INSERT INTO public.user_location_detail(
            id, is_active, location_type, location, user_id)
	VALUES (NEW.id, case when NEW.state = 'ACTIVE' then true else false end, NEW.type, new.loc_id, NEW.user_id);


if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'INSERT INTO public.um_user_location(
            id, created_by, created_on, modified_by, modified_on, loc_id, 
            state, type, user_id, level)
	   VALUES ('|| quote_nullable(NEW.id) || '
	   ,'|| quote_nullable(NEW.created_by) || '
	   ,'|| quote_nullable(NEW.created_on) || '
	   ,'|| quote_nullable(NEW.modified_by) || '
	   ,'|| quote_nullable(NEW.modified_on) || '
	   ,'|| quote_nullable(NEW.loc_id) || '
	   ,'|| quote_nullable(NEW.state) || '
	   ,'|| quote_nullable(NEW.type) || '
	   ,'|| quote_nullable(NEW.user_id) || '
	   ,'|| quote_nullable(NEW.level) || '
	   );'
        ); 
	end if;

    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;




CREATE OR REPLACE FUNCTION public.um_user_location_update_trigger_func()
  RETURNS trigger AS
$BODY$
BEGIN
	update user_location_detail 
	set is_active = case when NEW.state = 'ACTIVE' then true else false end , location_type = NEW.type,location = new.loc_id,user_id = NEW.user_id
	where id = NEW.id;

if (select case when key_value = 'P' then true else false end from system_configuration where system_key = 'SERVER_TYPE') then
	PERFORM dblink_exec
	(
		'dbname='||(select key_value from system_configuration where system_key = 'TRAINING_DB_NAME'),
		'UPDATE um_user_location SET id='|| quote_nullable(NEW.id) || 
		', created_by='|| quote_nullable(NEW.created_by) || 
		', created_on='|| quote_nullable(NEW.created_on) || 
		', modified_by='|| quote_nullable(NEW.modified_by) || 
		', modified_on='|| quote_nullable(NEW.modified_on) || 
		', loc_id='|| quote_nullable(NEW.loc_id) || 
		', state='|| quote_nullable(NEW.state) || 
		', type='|| quote_nullable(NEW.type) || 
		', user_id='|| quote_nullable(NEW.user_id) || 
		', level='|| quote_nullable(NEW.level) || '
		WHERE id='|| quote_nullable(NEW.id) || ';'

        ); 
	end if;
	
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

