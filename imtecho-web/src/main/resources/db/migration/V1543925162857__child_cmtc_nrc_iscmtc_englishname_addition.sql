alter table location_master
drop column if exists contains_cmtc_center,
drop column if exists is_cmtc_present,
drop column if exists english_name,
add column is_cmtc_present boolean,
add column english_name text