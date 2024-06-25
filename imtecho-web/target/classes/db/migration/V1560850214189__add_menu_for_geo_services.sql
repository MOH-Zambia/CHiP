insert into menu_config (active, menu_name,navigation_state,menu_type) values (true,'User GEO Services', 'techo.manage.usergeoservices','manage');


alter table rch_member_services
add column lat_long_location_distance double precision;


CREATE or replace FUNCTION getLocationByLatLongDist(lat text,lon text)
RETURNS double precision AS $$
DECLARE passed BOOLEAN;
--DECLARE geom1 geometry;
BEGIN
/*	IF (lat = 'null' or lat is null or lon = 'null' or lon is null or lon::float <= 0 or lat::float <= 0)
	THEN
		return 0;
	END IF;
	SELECT  geom  into geom1
		FROM location_geo_coordinates
		where st_contains(geom, ST_GeomFromText(CONCAT('POINT(',lat, ' ',lon, ')'),4326)) = true limit 1 ;
	return ST_Distance(geom1, ST_GeomFromText(CONCAT('POINT(71.53786519 21.11840804)'),4326));*/

END;
$$  LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION rch_member_services_scheduler() RETURNS integer AS $$
-- select rch_member_services_scheduler();

DECLARE previous_execute_date timestamp;
        BEGIN
                -- Getting prevous value
		--select key_value into previous_execute_date from system_configuration where system_key ='RCH_MEMBER_SERVICES_LAST_EXECUTE_DATE';
		-- update system_configuration set key_value = '2019-01-01' where system_key ='RCH_MEMBER_SERVICES_LAST_EXECUTE_DATE'
		select key_value::timestamp into previous_execute_date from system_configuration where system_key ='RCH_MEMBER_SERVICES_LAST_EXECUTE_DATE';


		CREATE TEMP TABLE rch_member_services_temp_member (id bigint);		-- Creating Temp table which contains all member id which are updates in any services
		CREATE TEMP TABLE rch_member_services_temp_member_distinct (id bigint);

		INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_lmp_follow_up WHERE modified_on>=previous_execute_date;
		INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_anc_master WHERE modified_on>=previous_execute_date;
		INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_wpd_mother_master WHERE modified_on>=previous_execute_date;
		  --INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_wpd_child_master WHERE modified_on>=previous_execute_date;
		INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_child_service_master WHERE modified_on>=previous_execute_date;
		INSERT INTO rch_member_services_temp_member SELECT member_id FROM rch_pnc_master WHERE modified_on>=previous_execute_date;


		INSERT INTO rch_member_services_temp_member_distinct SELECT distinct id from rch_member_services_temp_member;

		-- delete all member data which are updated
		DELETE FROM rch_member_services where member_id in (select id from rch_member_services_temp_member_distinct);

		-- Reinseting all data for lmp;
		INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
		SELECT
		location_id,created_by as user_id,member_id, service_date, 'FHW_LMP' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
		FROM rch_lmp_follow_up
		--WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member_distinct);
		WHERE member_id in (select id from rch_member_services_temp_member_distinct);

		-- Reinseting all data for anc;
		INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
		SELECT
		location_id,created_by as user_id,member_id, service_date, 'FHW_ANC' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
		FROM rch_anc_master
		--WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member);
		WHERE member_id in (select id from rch_member_services_temp_member_distinct);

		-- Reinseting all data for mother wpd;
		INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
		SELECT
		location_id,created_by as user_id,member_id, created_on as service_date, 'FHW_MOTHER_WPD' as service_type , created_on as server_date, id as visit_id, now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
		FROM rch_wpd_mother_master
		--WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member_distinct);
		WHERE member_id in (select id from rch_member_services_temp_member_distinct);

		-- Reinseting all data for child wpd;
		/*INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on)
		SELECT
		location_id,created_by as user_id,member_id, created_on as service_date, 'FHW_CHILD_WPD' as service_type , created_on as server_date, id as visit_id , now() as created_on
		FROM rch_wpd_child_master
		WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member);*/

		-- Reinseting all data for child server;
		INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,longitude,latitude,lat_long_location_id)
		SELECT
		location_id,created_by as user_id,member_id, service_date as service_date, 'FHW_CS' as service_type , created_on as server_date, id as visit_id,longitude,latitude,getLocationByLatLong(longitude,latitude)
		FROM rch_child_service_master
		--WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member_distinct);
		WHERE member_id in (select id from rch_member_services_temp_member_distinct);

		-- Reinseting all data for pnc;
		-- update rch_pnc_master set modified_on = now() where modified_on >  now(); //TODO need to discuss with harshitbhai

		INSERT INTO rch_member_services (location_id,user_id,member_id,service_date,service_type,server_date,visit_id,created_on,longitude,latitude,lat_long_location_id)
		SELECT
		location_id,created_by as user_id,member_id, service_date as service_date, 'FHW_PNC' as service_type , created_on as server_date, id as visit_id , now() as created_on,longitude,latitude,getLocationByLatLong(longitude,latitude)
		FROM rch_pnc_master
		--WHERE modified_on >= previous_execute_date or member_id in (select id from rch_member_services_temp_member_distinct);
		WHERE member_id in (select id from rch_member_services_temp_member_distinct);

		update system_configuration set key_value = now() where system_key='RCH_MEMBER_SERVICES_LAST_EXECUTE_DATE';

		DROP TABLE rch_member_services_temp_member;
		DROP TABLE rch_member_services_temp_member_distinct;


		return 1;
        END;
$$ LANGUAGE plpgsql;

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_geo_service_location_details','locationId','
with location_services as (
select
sum(case when (( (lat_long_location_id is not null and lat_long_location_id >0) and location.lgd_code != latLongLocation.lgd_code)) then 1 else 0 end) as incorrect_locations,
sum(case when location.lgd_code = latLongLocation.lgd_code then 1 else 0 end) as correct_locations,
sum(case when (lat_long_location_id is null or lat_long_location_id <= 0) then 1 else 0 end) as geo_not_available,
count(1) as total_services,
user_id
from rch_member_services  rlfu
inner join location_hierchy_closer_det lh  on lh.child_id = rlfu.location_id
					     and lh.parent_loc_type =''V'' and location_id in (select child_id from location_hierchy_closer_det where parent_id =#locationId#)
inner join location_master location on location.id = lh.parent_id
left join location_master latLongLocation on latLongLocation.id = rlfu.lat_long_location_id

group by user_id)
select ls.*, concat(um.first_name,'' '',um.last_name) as name
from location_services ls
inner join um_user um  on ls.user_id = um.id',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_geo_service_by_user_id','userId','
select user_id,
concat(um.first_Name, '' '' , um.last_name) as name,
concat(im.first_Name, '' '' , im.last_name) as "memberName",
get_location_hierarchy(lh.parent_id) as Location,
lh.parent_id as "locationId",
get_location_hierarchy(lat_long_location_id) as "latLongLocation",
location.lgd_Code as "locationLdgCode",
latLongLocation.lgd_Code as "latLongLocationLgdCode",
rlfu.latitude,
rlfu.longitude,
rlfu.lat_long_location_distance as "latLongLocationDistrance",
rlfu.service_type as "serviceType",
to_char(rlfu.service_date,''dd-MM-yyyy'') as "serviceDate"
from rch_member_services  rlfu
inner join location_hierchy_closer_det lh on lh.child_id = rlfu.location_id and lh.parent_loc_type =''V''
inner join um_user um on um.id = rlfu.user_id
inner join imt_member im on im.id = rlfu.member_id
inner join location_master location on location.id = lh.parent_id
inner join location_master latLongLocation on latLongLocation.id = lat_long_location_id
and lat_long_location_id is not null and lat_long_location_id <> 0
where user_id = #userId#
',true,'ACTIVE');

insert into query_master(created_by,created_on,code,params,query,returns_result_set,state)
values(1,current_date,'get_geo_map_by_lgdcode','lgdCode','
select ST_AsGeoJSON(geom) from location_geo_coordinates where lgd_code in (#lgdCode#);
',true,'ACTIVE');
