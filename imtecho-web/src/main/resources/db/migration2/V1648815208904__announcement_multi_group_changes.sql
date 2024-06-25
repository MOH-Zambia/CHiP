--5965

alter table announcement_location_detail
drop constraint announcement_location_detail_pkey;

alter table announcement_location_detail
add constraint announcement_location_detail_pkey primary key (announcement,location,announcement_for);