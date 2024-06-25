alter table rch_wpd_mother_master
drop column if exists institutional_delivery_place,
add column institutional_delivery_place text;

update rch_wpd_mother_master
set institutional_delivery_place = delivery_place
where is_from_web = true
and delivery_place is not null;

update rch_wpd_mother_master
set delivery_place = 'HOSP'
where is_from_web = true
and delivery_place = 'THISHOSP';