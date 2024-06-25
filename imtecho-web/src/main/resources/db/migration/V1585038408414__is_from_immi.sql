alter table covid_travellers_info
drop column if exists is_from_immigration,
add column is_from_immigration boolean;