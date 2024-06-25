create table anmol_location_master(
id bigserial PRIMARY KEY,
district_code bigint,
taluka_code bigint,
village_code bigint,
health_facility_code bigint,
health_subfacility_code bigint,
health_block_code bigint,
health_facility_type bigint,
asha_id bigint,
anm_id bigint);


alter table location_master
add column anmol_location_id bigint;

alter table anmol_location_master
add column state_code bigint;

alter table anmol_location_master
add column location_id bigint;

alter table anmol_location_master
alter column Taluka_Code type character varying(255);

create table anmol_child_master
(id bigserial PRIMARY KEY,
  anmol_master_id bigint,
  member_id bigint,
  case_no int,
  pregnancy_reg_det_id bigint,
  child_registration_id character varying(255),
  child_registration_status character varying(50),
  child_registration_wsdl_code text,
  child_registration_xml text,
  child_registration_date timestamp without time zone,
  child_id bigint,
  child_infant_registration_id character varying(255),
  child_infant_registration_status character varying(50),
  child_infant_registration_wsdl_code text,
  child_infant_registration_date timestamp without time zone,
  child_infant_registration_xml text);

alter table anmol_master
drop column child_registration_id,
drop column child_registration_wsdl_code,
drop column child_registration_xml,
drop column child_registration_date,
drop column child_infant_registration_id,
drop column child_registration_status,
drop column child_infant_registration_wsdl_code,
drop column child_infant_registration_xml,
drop column child_id;