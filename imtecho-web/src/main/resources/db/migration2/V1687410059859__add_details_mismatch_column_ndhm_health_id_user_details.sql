alter table ndhm_health_id_user_details
drop column if exists is_details_mismatch,
add column is_details_mismatch boolean,
drop column if exists location_id,
add column location_id integer;