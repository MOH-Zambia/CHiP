alter table location_master
add column rch_integration boolean;

update location_master set rch_integration = true where id=7170;