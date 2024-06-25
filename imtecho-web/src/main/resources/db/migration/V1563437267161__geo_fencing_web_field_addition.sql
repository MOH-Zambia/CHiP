alter table location_master
drop column if exists geo_fencing,
add column geo_fencing boolean;