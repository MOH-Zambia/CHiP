alter table notification_type_master
drop column if exists url_based_action,
drop column if exists url,
drop column if exists modal_based_action,
drop column if exists modal_name,
add column url_based_action boolean,
add column url text,
add column modal_based_action boolean,
add column modal_name text