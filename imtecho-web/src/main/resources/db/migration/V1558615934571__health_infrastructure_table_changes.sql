alter table health_infrastructure_details
drop column if exists no_of_beds,
add column no_of_beds integer;