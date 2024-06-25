ALTER TABLE migration_master
drop column if exists reported_location_id,
add column reported_location_id bigint;