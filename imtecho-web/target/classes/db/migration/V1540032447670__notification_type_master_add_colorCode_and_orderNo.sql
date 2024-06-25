alter table notification_type_master
drop column if exists order_no,
drop column if exists color_code,
add column order_no integer,
add column color_code character varying(10)