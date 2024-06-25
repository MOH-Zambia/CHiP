alter table covid_travellers_info
drop column if exists  is_update_location,
add column is_update_location boolean,
drop column if exists  update_location_by,
add column update_location_by integer,
drop column if exists previous_location,
add column previous_location integer;

alter table covid_travellers_screening_info
drop column if exists  is_update_location,
add column is_update_location boolean,
drop column if exists  update_location_by,
add column update_location_by integer,
drop column if exists previous_location,
add column previous_location integer;