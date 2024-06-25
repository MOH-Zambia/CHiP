alter table rch_wpd_mother_master
drop column if exists delivery_person_name,
add column delivery_person_name text;