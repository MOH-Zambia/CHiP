ALTER TABLE event_configuration_type
  ADD COLUMN query_master_id bigint;
ALTER TABLE event_configuration_type
  ADD COLUMN query_master_param_json text;