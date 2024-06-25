
alter table covid_travellers_info drop column IF EXISTS status;
ALTER TABLE covid_travellers_info
ADD COLUMN status text;

alter table covid_travellers_info drop column IF EXISTS input_type;
alter table covid_travellers_info add column input_type text;
