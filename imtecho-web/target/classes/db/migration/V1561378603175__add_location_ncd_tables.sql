ALTER TABLE ncd_member_cbac_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint;

ALTER TABLE ncd_member_breast_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;

ALTER TABLE ncd_member_diabetes_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;

ALTER TABLE ncd_member_cervical_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;

ALTER TABLE ncd_member_oral_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;

ALTER TABLE ncd_member_hypertension_detail
DROP COLUMN IF EXISTS location_id,
ADD COLUMN location_id bigint,
DROP COLUMN IF EXISTS family_id,
ADD COLUMN family_id bigint;


update ncd_member_breast_detail ncd
set location_id = case when f.area_id is null then f.location_id else f.area_id end,
family_id = f.id
from imt_member m, imt_family f where m.id = ncd.member_id
and m.family_id = f.family_id;

update ncd_member_diabetes_detail ncd
set location_id = case when f.area_id is null then f.location_id else f.area_id end,
family_id = f.id
from imt_member m, imt_family f where m.id = ncd.member_id
and m.family_id = f.family_id;

update ncd_member_cervical_detail ncd
set location_id = case when f.area_id is null then f.location_id else f.area_id end,
family_id = f.id
from imt_member m, imt_family f where m.id = ncd.member_id
and m.family_id = f.family_id;

update ncd_member_oral_detail ncd
set location_id = case when f.area_id is null then f.location_id else f.area_id end,
family_id = f.id
from imt_member m, imt_family f where m.id = ncd.member_id
and m.family_id = f.family_id;


update ncd_member_hypertension_detail ncd
set location_id = case when f.area_id is null then f.location_id else f.area_id end,
family_id = f.id
from imt_member m, imt_family f where m.id = ncd.member_id
and m.family_id = f.family_id;

INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
SELECT
location_id,created_by as user_id,member_id, screening_date as service_date, 'NCD_BREAST' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
FROM ncd_member_breast_detail;

INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
SELECT
location_id,created_by as user_id,member_id, screening_date as service_date, 'NCD_DIABETES' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
FROM ncd_member_diabetes_detail;

INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
SELECT
location_id,created_by as user_id,member_id, screening_date as service_date, 'NCD_CERVICAL' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
FROM ncd_member_cervical_detail;

INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
SELECT
location_id,created_by as user_id,member_id, screening_date as service_date, 'NCD_ORAL' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
FROM ncd_member_oral_detail;

INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
SELECT
location_id,created_by as user_id,member_id, screening_date as service_date, 'NCD_HYPERTENSION' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
FROM ncd_member_hypertension_detail;
