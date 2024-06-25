alter table chardham_tourist_screening_master
add column if not exists other_treatment text;

alter table chardham_tourist_screening_master
add column if not exists other_symptoms text;

alter table chardham_tourist_screening_master
add column if not exists treatment_status text;