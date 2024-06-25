alter table location_type_master
drop column if exists created_by,
add column created_by integer,
drop column if exists created_on,
add column created_on timestamp without time zone,
drop column if exists modified_by,
add column modified_by integer,
drop column if exists modified_on,
add column modified_on timestamp without time zone;

update location_type_master
set created_by = -1, modified_by = -1,
created_on = now(), modified_on = now();