alter table chardham_tourist_master
add column if not exists has_fever bool;

alter table chardham_tourist_screening_master
add column if not exists has_fever bool;