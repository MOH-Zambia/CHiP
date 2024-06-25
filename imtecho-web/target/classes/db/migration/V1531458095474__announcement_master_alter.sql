alter table announcement_info_master
add column modified_on timestamp without time zone,
add column modified_by bigint,
drop column if exists created_by, 
add column created_by bigint;