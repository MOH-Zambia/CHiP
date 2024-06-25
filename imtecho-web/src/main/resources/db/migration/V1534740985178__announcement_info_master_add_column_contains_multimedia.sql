alter table announcement_info_master
drop column if exists contains_multimedia,
add column contains_multimedia boolean