alter table if exists rch_hiv_known_master
add column if not exists family_id int,
add column if not exists location_id int;


alter table if exists rch_hiv_screening_master
add column if not exists family_id int,
add column if not exists location_id int;