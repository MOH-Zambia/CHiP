alter table um_role_master
drop column if exists is_geolocation_mandatory,
add column is_geolocation_mandatory boolean;