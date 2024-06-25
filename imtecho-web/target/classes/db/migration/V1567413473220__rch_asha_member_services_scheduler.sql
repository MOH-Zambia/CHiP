drop table if exists rch_asha_member_services;

CREATE TABLE rch_asha_member_services
(
  id bigserial NOT null PRIMARY KEY,
  location_id bigint,
  user_id bigint,
  member_id bigint,
  service_type character varying(50),
  service_date timestamp without time zone,
  server_date timestamp without time zone,
  created_on timestamp without time zone,
  visit_id bigint,
  longitude text,
  latitude text,
  lat_long_location_id bigint,
  lat_long_location_distance double precision,
  location_state character varying(50),
  geo_location_state character varying(50)
);

delete from system_configuration where system_key = 'RCH_ASHA_MEMBER_SERVICES_LAST_EXECUTE_DATE';

insert into system_configuration(key_value, system_key, is_active)
select to_timestamp(0), 'RCH_ASHA_MEMBER_SERVICES_LAST_EXECUTE_DATE', true;