create or replace function role_hierarchy_level_updation()
returns trigger
language PLPGSQL
as
$$
	begin
		update role_hierarchy_management
		set level = new.level
		where location_type = new.type;
		return new;
	end;
$$;

drop trigger if exists role_hierarchy_level_updation on location_type_master;

create trigger role_hierarchy_level_updation
after update
ON location_type_master
for each row
execute procedure role_hierarchy_level_updation();