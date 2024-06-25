create table drtecho_wpd_master(
id bigserial primary key,
user_id bigint,
first_name text,
middle_name text,
last_name text,
dob date,
aadhar_number text,
location_id bigint,
address text,
delivery_date timestamp without time zone,
health_infrastructure_id bigint,
json_data text,
created_by bigint,
created_on timestamp without time zone,
modified_by bigint,
modified_on timestamp without time zone
);