alter table covid_travellers_info DROP COLUMN IF EXISTS passport_no;
alter table covid_travellers_info add column passport_no text;

alter table covid_travellers_info DROP COLUMN IF EXISTS seat_no;
alter table covid_travellers_info add column seat_no text;