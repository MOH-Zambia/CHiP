alter table rch_pnc_master
drop column if exists delivery_place,
drop column if exists type_of_hospital,
drop column if exists health_infrastructure_id,
drop column if exists delivery_done_by,
drop column if exists delivery_person,
drop column if exists delivery_person_name,
add column delivery_place text,
add column type_of_hospital bigint,
add column health_infrastructure_id bigint,
add column delivery_done_by text,
add column delivery_person bigint,
add column delivery_person_name text;

alter table rch_child_service_master
drop column if exists delivery_place,
drop column if exists type_of_hospital,
drop column if exists health_infrastructure_id,
drop column if exists delivery_done_by,
drop column if exists delivery_person,
drop column if exists delivery_person_name,
add column delivery_place text,
add column type_of_hospital bigint,
add column health_infrastructure_id bigint,
add column delivery_done_by text,
add column delivery_person bigint,
add column delivery_person_name text;

alter table rch_anc_master
drop column if exists delivery_place,
drop column if exists type_of_hospital,
drop column if exists health_infrastructure_id,
drop column if exists delivery_done_by,
drop column if exists delivery_person,
drop column if exists delivery_person_name,
add column delivery_place text,
add column type_of_hospital bigint,
add column health_infrastructure_id bigint,
add column delivery_done_by text,
add column delivery_person bigint,
add column delivery_person_name text;