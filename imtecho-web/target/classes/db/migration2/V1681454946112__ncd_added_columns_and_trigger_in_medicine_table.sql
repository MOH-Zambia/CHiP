alter table if exists ncd_member_disesase_medicine
add column if not exists is_deleted boolean,
add column if not exists deleted_on timestamp without time zone;


drop table if exists ncd_member_medicine_history;
create table if not exists ncd_member_medicine_history(
	id serial PRIMARY KEY,
	member_id integer,
	medicine_id integer,
	old_frequency integer,
	new_frequency integer,
	old_duration integer,
	new_duration integer,
	old_quantity integer,
	new_quantity integer,
	old_expiry_date timestamp without time zone,
	new_expiry_date timestamp without time zone,
	created_date timestamp without time zone,
	old_is_active boolean,
	new_is_active boolean
);

CREATE OR REPLACE FUNCTION public.ncd_member_disesase_medicine_update_trigger_func()
    RETURNS trigger
	LANGUAGE 'plpgsql'
    COST 100
AS $BODY$

begin

if(new.is_deleted is null) then
insert
	into
		ncd_member_medicine_history (member_id,
		medicine_id,
	old_frequency,
	new_frequency,
	old_duration,
	new_duration,
	old_quantity,
	new_quantity,
	old_expiry_date,
	new_expiry_date ,
	created_date ,
	old_is_active ,
	new_is_active)
	values (new.member_id,
	new.medicine_id,
	old.frequency,
	new.frequency,
	old.duration,
	new.duration,
	old.quantity,
	new.quantity,
	old.expiry_date,
	new.expiry_date,
	now(),
	old.is_active,
	new.is_active);

end if;
return new;
end;
$BODY$;


DROP TRIGGER if exists ncd_member_disesase_medicine_update_trigger on ncd_member_disesase_medicine;
CREATE TRIGGER ncd_member_disesase_medicine_update_trigger
    AFTER UPDATE
    ON public.ncd_member_disesase_medicine
    FOR EACH ROW
    EXECUTE FUNCTION public.ncd_member_disesase_medicine_update_trigger_func();
