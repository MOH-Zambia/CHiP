
alter table imt_family
drop column if exists family_uuid,
add column family_uuid text,
drop column if exists outdoor_cooking_practices,
add column outdoor_cooking_practices boolean,
drop column if exists waste_disposal_available,
add column waste_disposal_available boolean,
drop column if exists handwash_available,
add column handwash_available boolean,
drop column if exists storage_meets_standard,
add column storage_meets_standard boolean,
drop column if exists water_safety_meets_standard,
add column water_safety_meets_standard boolean,
drop column if exists dishrack_available,
add column dishrack_available boolean,
drop column if exists complaint_of_insects,
add column complaint_of_insects boolean,
drop column if exists complaint_of_rodents,
add column complaint_of_rodents boolean,
drop column if exists separate_livestock_shelter,
add column separate_livestock_shelter boolean;

alter table imt_member
drop column if exists nrc_number,
add column nrc_number text,
drop column if exists mother_name,
add column mother_name text;
