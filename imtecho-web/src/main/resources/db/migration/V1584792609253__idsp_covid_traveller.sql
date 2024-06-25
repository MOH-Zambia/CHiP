alter table idsp_member_screening_details
drop column if exists covid_symptoms,
add column covid_symptoms text,
drop column if exists other_covid_symptoms,
add column other_covid_symptoms text,
drop column if exists covid_traveller_info_id,
add column covid_traveller_info_id integer,
drop column if exists country,
add column country integer;