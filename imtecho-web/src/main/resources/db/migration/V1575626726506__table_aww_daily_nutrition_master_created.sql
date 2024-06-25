drop table if exists aww_daily_nutrition_master;
create table aww_daily_nutrition_master
(
id serial,
is_center_opened boolean,
selected_childrens text,
is_center_opened_by_someone boolean,
center_opened_by text,
reason_for_center_not_opened text,
reason_for_center_opened_by_someone text,
other_reason_for_center_opened_by_someone text,

user_id bigint,
latitude text,
longitude text,
mobile_start_date timestamp without time zone,
mobile_end_date timestamp without time zone,
location_id bigint,
location_hierarchy_id bigint,

created_on timestamp without time zone,
created_by bigint,
modified_by bigint,
modified_on timestamp without time zone

);