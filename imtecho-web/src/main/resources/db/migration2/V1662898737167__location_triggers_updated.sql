CREATE OR REPLACE FUNCTION public.location_master_update_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	if NEW.type <> OLD.type then
		update location_hierchy_closer_det set child_loc_type = NEW.type where child_id = NEW.id;
		update location_hierchy_closer_det set parent_loc_type = NEW.type where parent_id = NEW.id;
		update location_level_hierarchy_master set location_type = NEW.type where location_id = NEW.id;
	end if;

	if OLD.parent is null and NEW.parent is not null then
		INSERT INTO location_hierchy_closer_det
			(child_id, child_loc_type, depth, parent_id, parent_loc_type)
		select
			c.child_id,c.child_loc_type,
			p.depth + c.depth + 1,
			p.parent_id,
			p.parent_loc_type
		FROM
			location_hierchy_closer_det p,
			location_hierchy_closer_det c
		WHERE
			p.child_id = NEW.parent
			AND c.parent_id = NEW.id;
	end if;

	if OLD.parent is not null and NEW.parent <> OLD.parent then
	update location_hierchy_closer_det lh set parent_id = t.parent_id ,parent_loc_type = t.parent_loc_type,parent_loc_demographic_type = t.parent_loc_demographic_type
	from (
		select d.parent_id ,d.parent_loc_type ,d.parent_loc_demographic_type,c.id
		from location_hierchy_closer_det p , location_hierchy_closer_det c , location_hierchy_closer_det d
		where p.parent_id = new.id and p.child_id = c.child_id and d.child_id = new.parent and (c."depth" - p."depth" -1) = d."depth"
	) t where t.id =lh.id and lh.parent_id != t.parent_id ;

		/*--update location_hierchy_closer_det set parent_id = NEW.parent,parent_loc_type = (select type from location_master where id =NEW.parent)
		where id in (select id from location_hierchy_closer_det where child_id in (select child_id from location_hierchy_closer_det where parent_id = NEW.id) and parent_id =OLD.parent);

--		update location_hierchy_closer_det closer1 set parent_id = closer2.parent_id from location_hierchy_closer_det closer2
--	    where closer1.child_id = NEW.id and closer1.depth > 0 and closer2.child_id = new.parent
--	    and closer1.depth = closer2.depth+1 and closer1.parent_id <> closer2.parent_id
--	    and closer1.parent_id not in (-1, -2) and closer2.parent_id not in (-1, -2);

		/* query to update location_hierchy_closer_det table
		update
			location_hierchy_closer_det closer1
		set
			parent_id = closer2.parent_id
		from
			location_hierchy_closer_det closer2
		inner join
			location_type_master type2 on type2."type" = closer2.parent_loc_type
        where
        	closer1.child_id in (select child_id from location_hierchy_closer_det where child_id in (select child_id from location_hierchy_closer_det where parent_id = NEW.id) and parent_id =OLD.parent)
        	and closer1.depth > 0 and closer2.child_id = new.parent
	        and (select level from location_type_master where type = closer1.parent_loc_type) = type2."level"
        	and closer1.parent_id <> closer2.parent_id
        	and closer1.parent_id not in (-1, -2)
        	and closer2.parent_id not in (-1, -2);
        	*/

	-- DELETE EXISTING RECORDS FROM CLOSURE
		delete from location_hierchy_closer_det where child_id  = new.id;
	   	--INSERT FIRST RECORD OF LOCATION (SAME PARENT, SAME CHILD)
		INSERT INTO public.location_hierchy_closer_det(
            child_id, child_loc_type, depth, parent_id, parent_loc_type)
    	VALUES ( new.id, new.type, 0, new.id, new.type);
    	--INSERT ALL OTHER PARENTS OF LOCATION
	   	INSERT INTO public.location_hierchy_closer_det(
            child_id, child_loc_type, depth, parent_id, parent_loc_type)
		SELECT  c.child_id,c.child_loc_type, p.depth+c.depth+1,p.parent_id,p.parent_loc_type
		FROM location_hierchy_closer_det p, location_hierchy_closer_det c
		WHERE p.child_id = new.parent AND c.parent_id = new.id and c.child_id = new.id;

        /* query to update location_level_hierarchy_master table */
         */

        update
        	location_level_hierarchy_master
        set
	        level1 = loc.level1,
			level2 = loc.level2 ,
			level3 = loc.level3 ,
			level4 = loc.level4 ,
			level5 = loc.level5 ,
			level6 = loc.level6 ,
			level7 = loc.level7 ,
			level8 = loc.level8
		from (
			select
				closer2.child_id as location_id,
				max (case when location_type_master.level = 1 then closer2.parent_id end) as level1,
				max (case when location_type_master.level = 2 then closer2.parent_id end) as level2,
				max (case when location_type_master.level = 3 then closer2.parent_id end) as level3,
				max (case when location_type_master.level = 4 then closer2.parent_id end) as level4,
				max (case when location_type_master.level = 5 then closer2.parent_id end) as level5,
				max (case when location_type_master.level = 6 then closer2.parent_id end) as level6,
				max (case when location_type_master.level = 7 then closer2.parent_id end) as level7,
				max (case when location_type_master.level = 8 then closer2.parent_id end) as level8
			from
				location_hierchy_closer_det closer1,
				location_hierchy_closer_det closer2,
				location_type_master
			where
				closer1.parent_id = NEW.id
				and closer1.child_id = closer2.child_id
				and location_type_master.type = closer2.parent_loc_type
			group by
				closer2.child_id
		) as loc
		where
			loc.location_id = location_level_hierarchy_master.location_id;
	end if;


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
$function$
;















CREATE OR REPLACE FUNCTION public.location_master_insert_trigger_func()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$ BEGIN
INSERT INTO public.location_hierchy_closer_det(
        child_id,
        child_loc_type,
        depth,
        parent_id,
        parent_loc_type
    )
VALUES (NEW.id, NEW.type, 0, NEW.id, NEW.type);
if NEW.parent is not null then
INSERT INTO public.location_hierchy_closer_det(
        child_id,
        child_loc_type,
        depth,
        parent_id,
        parent_loc_type
    )
SELECT c.child_id,
    c.child_loc_type,
    p.depth + c.depth + 1,
    p.parent_id,
    p.parent_loc_type
FROM location_hierchy_closer_det p,
    location_hierchy_closer_det c
WHERE p.child_id = NEW.parent
    AND c.parent_id = NEW.id;
END if;
insert into location_wise_analytics (loc_id)
VALUES (NEW.id);
if (
    select case
            when key_value = 'P' then true
            else false
        end
    from system_configuration
    where system_key = 'SERVER_TYPE'
) then
insert into location_level_hierarchy_master(
        location_id,
        level1,
        level2,
        level3,
        level4,
        level5,
        level6,
        level7,
        level8,
        location_type,
        is_active
    )
select closer2.child_id as location_id,
    max (
        case
            when location_type_master.level = 1 then closer2.parent_id
        end
    ) as level1,
    max (
        case
            when location_type_master.level = 2 then closer2.parent_id
        end
    ) as level2,
    max (
        case
            when location_type_master.level = 3 then closer2.parent_id
        end
    ) as level3,
    max (
        case
            when location_type_master.level = 4 then closer2.parent_id
        end
    ) as level4,
    max (
        case
            when location_type_master.level = 5 then closer2.parent_id
        end
    ) as level5,
    max (
        case
            when location_type_master.level = 6 then closer2.parent_id
        end
    ) as level6,
    max (
        case
            when location_type_master.level = 7 then closer2.parent_id
        end
    ) as level7,
    max (
        case
            when location_type_master.level = 8 then closer2.parent_id
        end
    ) as level8,
    new.type,
    true
from location_hierchy_closer_det closer1,
    location_hierchy_closer_det closer2,
    location_type_master
where closer1.parent_id = NEW.id
    and closer1.child_id = closer2.child_id
    and location_type_master.type = closer2.parent_loc_type
group by closer2.child_id;
update location_master lm
set location_hierarchy_id = llh.id
from location_level_hierarchy_master llh
where llh.location_id = lm.id
    and lm.id = new.id;
PERFORM dblink_exec (
    'dbname=' ||(
        select key_value
        from system_configuration
        where system_key = 'TRAINING_DB_NAME'
    ),
    'INSERT INTO location_master(
            id, address, associated_user, contact1_email, contact1_name,
            contact1_phone, contact2_email, contact2_name, contact2_phone,
            created_by, created_on, is_active, is_archive, max_users, modified_by,
            modified_on, name,english_name, pin_code, type, unique_id, parent, is_tba_avaiable,
            total_population, location_hierarchy_id, location_code, state)
	       Values (' || quote_nullable(NEW.id) || '
			, ' || quote_nullable(NEW.address) || '
			, ' || quote_nullable(NEW.associated_user) || '
			, ' || quote_nullable(NEW.contact1_email) || '
			, ' || quote_nullable(NEW.contact1_name) || '
			, ' || quote_nullable(NEW.contact1_phone) || '
			, ' || quote_nullable(NEW.contact2_email) || '
			, ' || quote_nullable(NEW.contact2_name) || '
			, ' || quote_nullable(NEW.contact2_phone) || '
			, ' || quote_nullable(NEW.created_by) || '
			, ' || quote_nullable(NEW.created_on) || '
			, ' || quote_nullable(NEW.is_active) || '
			, ' || quote_nullable(NEW.is_archive) || '
			, ' || quote_nullable(NEW.max_users) || '
			, ' || quote_nullable(NEW.modified_by) || '
			, ' || quote_nullable(NEW.modified_on) || '
			, ' || quote_nullable(NEW.name) || '
			, ' || quote_nullable(NEW.english_name) || '
			, ' || quote_nullable(NEW.pin_code) || '
			, ' || quote_nullable(NEW.type) || '
			, ' || quote_nullable(NEW.unique_id) || '
			, ' || quote_nullable(NEW.parent) || '
			, ' || quote_nullable(NEW.is_tba_avaiable) || '
			, ' || quote_nullable(NEW.total_population) || '
			, ' || quote_nullable(NEW.location_hierarchy_id) || '
			, ' || quote_nullable(NEW.location_code) || '
			, ' || quote_nullable(NEW.state) || ');'
);
end if;
if new.type = 'SC'
or new.type = 'P' then
INSERT INTO rch_institution_master(name, location_id, type, is_location, state)
VALUES (new.name, new.id, new.type, true, 'active');
end if;
if new.type = 'SC'
or new.type = 'P'
or new.type = 'U'
or new.type = 'CHC' then
INSERT INTO health_infrastructure_details(
        location_id,
        type,
        name,
        state,
        created_on,
        created_by,
        modified_on,
        modified_by
    )
values(
        New.id,
        (
            select id
            from listvalue_field_value_detail
            where field_key = 'infra_type'
                and code = new.type
        ),
        new.name,
        'ACTIVE',
        new.created_on,
        cast(new.created_by as bigint),
        new.modified_on,
        cast(new.modified_by as bigint)
    );
end if;
RETURN NEW;
END;
$function$
;
