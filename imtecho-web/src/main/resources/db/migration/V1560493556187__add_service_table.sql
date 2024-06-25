create table rch_member_services
(id bigserial primary key,
location_id bigint,
user_id bigint,
member_id bigint,
service_type character varying (50),
service_date timestamp without time zone,
server_date timestamp without time zone,
created_on timestamp without time zone,
visit_id bigint);

alter table rch_member_services
add column longitude text;

alter table rch_member_services
add column latitude text;

alter table rch_member_services
add column lat_long_location_id bigint;

insert into system_configuration VALUES('RCH_MEMBER_SERVICES_LAST_EXECUTE_DATE',true,'2018-01-01 00:00:00');



CREATE or replace FUNCTION getLocationByLatLong(lat text,lon text)
RETURNS bigint AS $$
DECLARE passed BOOLEAN;
DECLARE ldgCode text;
BEGIN
	IF (lat = 'null' or lat is null or lon = 'null' or lon is null or lon::float <= 0 or lat::float <= 0)
	THEN
		return 0;
	END IF;
	SELECT  lgd_code  into ldgCode
		FROM location_geo_coordinates
		where st_contains(geom, ST_GeomFromText(CONCAT('POINT(',lat, ' ',lon, ')'),4326)) = true limit 1 ;
	return (select id from location_master where lgd_code = ldgCode and type='V' limit 1);

END;
$$  LANGUAGE plpgsql;


