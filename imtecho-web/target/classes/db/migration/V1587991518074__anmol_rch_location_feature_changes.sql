/*
old anmol_location_master -> anmol_location_mapping

insert_rch_location_hierarchy
update_rch_location
retrieval_next_level_rch_locations

--

anmol_locations_master -> anmol_location_master

insert_rch_location_hierarchy
update_rch_location
retrieval_parent_rch_location
insert_rch_location
retrieval_next_level_rch_locations
*/

-- First rename table anmol_location_master to anmol_location_mapping

ALTER TABLE anmol_location_master
RENAME TO anmol_location_mapping;

-- Then rename table anmol_locations_master to anmol_location_master

--ALTER TABLE anmol_locations_master
--RENAME TO anmol_location_master;

----------------------------

alter table anmol_location_mapping
drop column if exists created_by,
add column created_by integer NULL,
drop column if exists created_on,
add column created_on timestamp without time zone NULL,
drop column if exists modified_by,
add column modified_by integer NULL,
drop column if exists modified_on,
add column modified_on timestamp without time zone NULL;
