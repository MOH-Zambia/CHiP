create table if not exists mytecho_user (
id bigserial,
user_name text,
first_name text,
middle_name text,
last_name text,
mobile_number text,
unique_health_id text,
member_id bigint,
location_id bigint,
latitude character varying(100),
longitude character varying(100),
created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);