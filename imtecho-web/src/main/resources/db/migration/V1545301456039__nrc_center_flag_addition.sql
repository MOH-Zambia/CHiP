alter table location_master
drop column if exists is_nrc_present,
add column is_nrc_present boolean;