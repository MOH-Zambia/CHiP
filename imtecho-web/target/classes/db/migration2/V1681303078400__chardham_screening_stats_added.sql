alter table chardham_tourist_screening_master
add column if not exists screening_from text;

alter table chardham_tourist_master
add column if not exists is_offline boolean;