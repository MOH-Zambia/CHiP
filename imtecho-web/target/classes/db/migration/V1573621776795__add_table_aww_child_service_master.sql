drop table if exists aww_child_service_master;
create table aww_child_service_master
(
id bigserial,
height integer,
weight real,
service_date date,

member_id bigint,
family_id bigint,
latitude text,
longitude text,
mobile_start_date timestamp without time zone,
mobile_end_date timestamp without time zone,
location_id bigint,
location_hierarchy_id bigint,
notification_id bigint,

created_on timestamp without time zone,
created_by bigint,
modified_by bigint,
modified_on timestamp without time zone

);