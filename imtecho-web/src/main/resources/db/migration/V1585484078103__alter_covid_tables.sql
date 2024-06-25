alter table covid_travellers_screening_info
drop column if exists update_location_reason,
add column update_location_reason text,
drop column if exists other_update_location_reason,
add column other_update_location_reason text;

alter table covid_travellers_info
drop column if exists update_location_reason,
add column update_location_reason text,
drop column if exists other_update_location_reason,
add column other_update_location_reason text;