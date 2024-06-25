ALTER TABLE location_master ADD CONSTRAINT location_master_unique_key UNIQUE (name, parent);
