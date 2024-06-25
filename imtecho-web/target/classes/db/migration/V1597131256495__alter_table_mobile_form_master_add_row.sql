alter table mobile_form_master
drop column if exists row,
add column row integer;