alter table imt_family
drop column if exists no_of_mosquito_nets_available,
add column no_of_mosquito_nets_available integer;