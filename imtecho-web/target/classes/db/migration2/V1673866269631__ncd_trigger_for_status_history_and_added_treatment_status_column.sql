ALTER TABLE IF EXISTS ncd_member_breast_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE IF EXISTS ncd_member_cervical_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE IF EXISTS ncd_member_oral_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE IF EXISTS ncd_member_general_detail
	ADD COLUMN IF NOT EXISTS treatment_status text;

ALTER TABLE IF EXISTS ncd_member_general_detail
	ADD COLUMN IF NOT EXISTS take_medicine boolean;

DROP TABLE IF EXISTS ncd_member_status_history;
CREATE TABLE IF NOT EXISTS ncd_member_status_history(
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    from_status character varying(50),
	to_status character varying(50),
	from_sub_status character varying(50),
	to_sub_status character varying(50),
	disease_code character varying(20)
);


CREATE OR REPLACE FUNCTION public.update_ncd_status_trigger()
    RETURNS trigger
	LANGUAGE 'plpgsql'
    COST 100
AS $BODY$

begin

if (TG_OP = 'INSERT') then
insert
	into
		ncd_member_status_history (member_id,
		from_status,
		to_status,
		from_sub_status,
		to_sub_status,
		disease_code,
		created_by,
		created_on,
		modified_by,
		modified_on)
	values (new.member_id,
	null,
	new.status,
	null,
	new.sub_status,
	new.disease_code,
	new.modified_by,
	now(),
	new.modified_by,
	now());
end if;


if (TG_OP != 'INSERT'
and (new.status != old.status or new.sub_status != old.sub_status or old.sub_status is null)) then
insert
	into
		ncd_member_status_history (member_id,
		from_status,
		to_status,
		from_sub_status,
		to_sub_status,
		disease_code,
		created_by,
		created_on,
		modified_by,
		modified_on)
	values (new.member_id,
	old.status,
	new.status,
	old.sub_status,
	new.sub_status,
	new.disease_code,
	new.modified_by,
	now(),
	new.modified_by,
	now());
end if;

return new;
end;
$BODY$;


DROP TRIGGER if exists update_ncd_status_trigger on ncd_master;
CREATE TRIGGER update_ncd_status_trigger
    BEFORE UPDATE
    ON public.ncd_master
    FOR EACH ROW
    EXECUTE FUNCTION public.update_ncd_status_trigger();

DROP TRIGGER if exists insert_ncd_status_trigger on ncd_master;
CREATE TRIGGER insert_ncd_status_trigger
    BEFORE INSERT
    ON public.ncd_master
    FOR EACH ROW
    EXECUTE FUNCTION public.update_ncd_status_trigger();