alter table gvk_anm_verification_response
drop column if exists delivery_health_infrastructure_verification,
drop column if exists delivery_health_infrastructure_id,
drop column if exists delivery_done_by_verification,
drop column if exists delivery_done_by,
drop column if exists other_facility_visited,
drop column if exists no_of_hospitals_visited,
drop column if exists facility_details,
drop column if exists version,
add column delivery_health_infrastructure_verification boolean,
add column delivery_health_infrastructure_id integer,
add column delivery_done_by_verification boolean,
add column delivery_done_by character varying(20),
add column other_facility_visited boolean,
add column no_of_hospitals_visited integer,
add column facility_details text,
add column version integer;

begin;
update gvk_anm_verification_response
set version = 1
where version is null;
commit;