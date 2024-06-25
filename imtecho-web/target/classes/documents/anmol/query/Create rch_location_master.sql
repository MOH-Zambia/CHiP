-------------------------------------------------
-- Location Master Type
-------------------------------------------------
-- | type       |   name                |   level
-------------------------------------------------
-- | S          |   State	            |   1
-- | R	        |   Region	            |   2
-- | C	        |   Corporation	        |   3
-- | D	        |   District	        |   3
-- | B	        |   Block	            |   4
-- | Z	        |   Zone	            |   4
-- | P	        |   PHC	                |   5
-- | U	        |   UPHC	            |   5
-- | SC	        |   Sub Center	        |   6
-- | ANM        |   ANM Area	        |   6
-- | V	        |   Village	            |   7
-- | ANG	    |   Anganwadi Area	    |   7
-- | A	        |   Area	            |   8
-- | AA	        |   Asha Area           |   8


--------------------------------------------------------------
-- Anmol Location Master Type
--------------------------------------------------------------
-- | type   | techo_type  |   name              |   level
--------------------------------------------------------------
-- | S      |  S          |   State             |   1 // 1
-- | -      |  -          |   -                 |   - // 2
-- | D	    |  D          |   District	        |   2 // 3
-- | T	    |  B          |   Taluka            |   3 // 4
-- | HB     |  -          |   Health Block      |   4 // -
-- | F      |  P          |   Facility          |   4 // 5
-- | FU     |  U          |   U Facility        |   4 // 5 +++
-- | SF     |  SC         |   Sub Facility      |   5 // 6
-- | SF_ANM |  ANM        |   Sub Facility ANM  |   5 // 6 ***
-- | V      |  V          |   Village           |   6 // 7
-- | V_ANG  |  ANG        |   Village ANG       |   6 // 7 ***
--------------------------------------------------------------

-- State (S, S) -> 1, 1
-- District (D, D) -> 34, 33
-- Taluka (B, T) -> 249, 248
-- Health Block (T, HB) -> 248, 261 (anmol_location_master, anmol_location_master)
-- Facility (P, F) -> 1482, 1477
-- U Facility (U, FU) -> 175, 174
-- Sub Facility (SC, SF) -> 9200, 9181
-- Village (V, V) -> 20491, 19020


drop table if exists anmol_location_master;
create table anmol_location_master (
  id serial,
  name varchar(100),
  english_name varchar(100),
  type varchar(55) not null,
  techo_location_type varchar(55) not null,
  -- location_id integer not null,
  rch_code varchar(255) not null,
  parent_type varchar(55) not null,
  techo_parent_location_type varchar(55) not null,
  -- parent_location_id integer not null,
  parent_rch_code varchar(255) not null,
  asha_id integer,
  anm_id integer,
  created_by integer NOT NULL,
  created_on timestamp without time zone NOT NULL,
  modified_by integer NOT NULL,
  modified_on timestamp without time zone NOT NULL,
  constraint unique_type_and_rch_code UNIQUE (type, rch_code)
);

-- insert districts

with locations_group as (
  select
    location.district_code as code,
    location.state_code as parent_code
  from anmol_location_mapping location
  group by
    location.district_code,
    location.state_code
),
locations as (
  select
    yyy_anmol.name_g as name,
    yyy_anmol.name_e as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'D' as type,
    'D' as techo_location_type,
    'S' as parent_type,
    'S' as techo_parent_location_type
  from locations_group anmol
  inner join yyy_anmol_district yyy_anmol on cast(yyy_anmol.dcode as text) = cast(anmol.code as text)
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert taluka

with locations_group as (
  select
    lm.name as name,
    lm.english_name as english_name,
    location.taluka_code as code,
    location.district_code as parent_code
  from anmol_location_mapping location
  inner join location_master lm on cast(lm.rch_code as text) = cast(location.taluka_code as text) and lm.type = 'B'
  group by
    lm.name,
    lm.english_name,
    location.taluka_code,
    location.district_code
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'T' as type,
    'B' as techo_location_type,
    'D' as parent_type,
    'D' as techo_parent_location_type
  from locations_group anmol
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert health_blocks

/* with temp as (
  select
    distinct health_block_code
  from
    anmol_location_mapping
),
temp2 as (
  select
    block.*
  from
    yyy_anmol_health_block block
  left join
    temp on block.bid = temp.health_block_code
  where temp.health_block_code is not null
), */
with
locations_group as (
  select
    location.name_g as name,
    location.name_e as english_name,
    location.bid as code,
    location.tcode as parent_code
  -- from temp2 location
  from yyy_anmol_health_block location
  group by
    location.bid,
    location.tcode,
    location.name_g,
    location.name_e
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'HB' as type,
    'HB' as techo_location_type,
    'T' as parent_type,
    'B' as techo_parent_location_type
  from locations_group anmol
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert facility (PHC)

with locations_group as (
  select
    location.name_g as name,
    location.name_e as english_name,
    location.pid as code,
    location.tcode as parent_code
  from yyy_anmol_health_phc location
  inner join anmol_location_master master on cast(master.rch_code as text) = cast(location.dcode as text) and master.type = 'D'
  inner join location_master lm on cast(lm.rch_code as text) = cast(location.pid as text) and lm.type = 'P'
  group by
    location.pid,
    location.tcode,
    location.name_g,
    location.name_e
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'F' as type,
    'P' as techo_location_type,
    'T' as parent_type,
    'B' as techo_parent_location_type
  from locations_group anmol
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert u facility (UPHC)

with locations_group as (
  select
    location.name_g as name,
    location.name_e as english_name,
    location.pid as code,
    location.tcode as parent_code
  from yyy_anmol_health_phc location
  inner join anmol_location_master master on cast(master.rch_code as text) = cast(location.dcode as text) and master.type = 'D'
  inner join location_master lm on cast(cast(lm.rch_code as int) + 200000 as text) = cast(location.pid as text) and lm.type = 'U'
    and lm.id in (select child_id from location_hierchy_closer_det where parent_loc_type IN ('D'))
  group by
    location.pid,
    location.tcode,
    location.name_g,
    location.name_e
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'FU' as type,
    'U' as techo_location_type,
    'T' as parent_type,
    'B' as techo_parent_location_type
  from locations_group anmol
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert sub facility (SC)

with max_id_locations as (
  select
  max(id) as max_id,
  rch_code
  from location_master
  where type = 'SC'
  group by rch_code
),
locations_group as (
  select
    lm.id as location_id,
    location.name_g as name,
    location.name_e as english_name,
    location.sid as code,
    location.pid as parent_code
  from yyy_anmol_health_subcentre location
  left join max_id_locations mil on cast(mil.rch_code as text) = cast(location.sid as text)
  left join location_master lm on lm.id = mil.max_id
  group by
    lm.id,
    location.sid,
    location.pid,
    location.name_g,
    location.name_e
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'SF' as type,
    'SC' as techo_location_type,
    case
      when lm.type = 'P' then 'F'
      when lm.type = 'U' then 'FU'
      else '-'
    end as parent_type,
    case
      when lm.type is not null then lm.type
      else '-'
    end as techo_parent_location_type
  from locations_group anmol
  left join location_master lm on lm.id = (select parent from location_master where id = anmol.location_id)
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations;

-- insert sub facility ANM (ANM)

/* with max_id_locations as (
  select
  max(id) as max_id,
  rch_code
  from location_master
  where type = 'ANM'
  group by rch_code
),
locations_group as (
  select
    lm.id as location_id,
    location.name_g as name,
    location.name_e as english_name,
    location.sid as code,
    location.pid as parent_code
  from yyy_anmol_health_subcentre location
  inner join max_id_locations mil on cast(mil.rch_code as text) = cast(location.sid as text)
  inner join location_master lm on lm.id = mil.max_id
  group by
    lm.id,
    location.sid,
    location.pid,
    location.name_g,
    location.name_e
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    'SF_ANM' as type,
    'ANM' as techo_location_type,
    case
      when lm.type = 'P' then 'F'
      when lm.type = 'U' then 'FU'
      else null
    end as parent_type,
    lm.type as techo_parent_location_type
  from locations_group anmol
  inner join location_master lm on lm.id = (select parent from location_master where id = anmol.location_id)
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, -1, now(), -1, now() from locations; */

-- insert villages

with max_id_locations as (
  select
  max(id) as max_id,
  rch_code
  from location_master
  where type = 'V'
  group by rch_code
),
locations_group as (
  select
    lm.id as location_id,
    lm.name as name,
    lm.english_name as english_name,
    location.village_code as code,
    location.health_subfacility_code as parent_code,
    location.asha_id,
    location.anm_id
  from anmol_location_mapping location
  inner join max_id_locations mil on cast(mil.rch_code as text) = cast(location.village_code as text)
  inner join location_master lm on lm.id = mil.max_id
  group by
    lm.id,
    lm.name,
    lm.english_name,
    location.health_subfacility_code,
    location.village_code,
    location.asha_id,
    location.anm_id
),
locations as(
  select
    anmol.name as name,
    anmol.english_name as english_name,
    anmol.code as rch_code,
    anmol.parent_code as parent_rch_code,
    anmol.asha_id as asha_id,
    anmol.anm_id as anm_id,
    'V' as type,
    'V' as techo_location_type,
    case
      when lm.type = 'SC' then 'SF'
      when lm.type = 'ANM' then 'SF_ANM'
      else null
    end as parent_type,
    lm.type as techo_parent_location_type
  from locations_group anmol
  inner join location_master lm2 on lm2.id = anmol.location_id
  inner join location_master lm on lm.id = lm2.parent
)
insert into anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, asha_id, anm_id, created_by, created_on, modified_by, modified_on)
select name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, asha_id, anm_id, -1, now(), -1, now() from locations;

-- Insert record for State 'Gujarat'

INSERT
INTO
anmol_location_master (name, english_name, type, techo_location_type, parent_type, techo_parent_location_type, rch_code, parent_rch_code, created_by, created_on, modified_by, modified_on)
VALUES ('ગુજરાત', 'Gujarat', 'S', 'S', '', '', '24', '', -1, now(), -1, now());


-------------------------------------------------------------------------

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