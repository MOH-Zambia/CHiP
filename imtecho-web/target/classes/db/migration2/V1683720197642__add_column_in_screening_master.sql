alter table chardham_tourist_screening_master
add column if not exists tourist_willing_to_continue boolean;

alter table chardham_tourist_screening_master
add column if not exists checksum text;