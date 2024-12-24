ALTER TABLE rch_child_service_master
ADD COLUMN if NOT exists isDeWormingGiven boolean;

update system_configuration set key_value = '116' where system_key = 'MOBILE_FORM_VERSION';
