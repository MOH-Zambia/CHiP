ALTER TABLE covid_travellers_screening_info
drop column if exists symptoms,
add column symptoms text,
drop column if exists other_symptoms,
add column other_symptoms text;

alter table covid_travellers_info
drop column if exists tracking_start_date,
add column tracking_start_date timestamp without time zone;
