alter table rch_pregnancy_registration_det
drop column if exists delivery_date,
add column delivery_date date;