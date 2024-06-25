
Drop table if exists anmol_location_mapping_master;
create table if not exists anmol_location_mapping_master (
id serial NOT NULL,
state_code varchar,
district_code varchar,
taluka_code varchar,
health_block_code varchar,
health_facility_code varchar,
health_subfacility_code varchar,
village_code varchar,
CONSTRAINT anmol_location_mapping_master_pkey PRIMARY KEY (id)
);
INSERT INTO anmol_location_mapping_master (state_code, district_code, taluka_code,health_block_code,health_facility_code,health_subfacility_code,village_code )
with anmol_location_mapping_master as (
select
s.rch_code as state_code,
d.rch_code as district_code,
t.rch_code as taluka_code,
db.rch_code as health_block_code,
f.rch_code as health_facility_code,
sf.rch_code health_subfacility_code,
village.rch_code as village_code
from anmol_location_master village
left join anmol_location_master sf on village.parent_rch_code = sf.rch_code and sf.type='SF'
left join anmol_location_master f on sf.parent_rch_code = f.rch_code and f.type in ('F', 'FU')
left join anmol_location_master t on f.parent_rch_code = t.rch_code and t.type='T'
left join anmol_location_master d on t.parent_rch_code = d.rch_code and d.type='D'
left join anmol_location_master S on d.parent_rch_code = S.rch_code and s.type='S'
left join anmol_location_master db on db.parent_rch_code = t.rch_code and db.type='HB'
where village.type='V')
select * from anmol_location_mapping_master;
