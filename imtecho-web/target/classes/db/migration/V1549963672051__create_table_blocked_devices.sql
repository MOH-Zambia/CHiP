drop table if exists blocked_devices_master;
create table blocked_devices_master (
	imei text primary key,
	created_by bigint,
	created_on timestamp without time zone
);