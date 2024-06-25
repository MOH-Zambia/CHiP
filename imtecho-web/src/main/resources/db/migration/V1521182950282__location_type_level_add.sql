ALTER TABLE location_type_master ADD COLUMN level integer;

ALTER TABLE role_hierarchy_management ADD COLUMN level integer;

UPDATE location_type_master SET level = 7 WHERE type = 'A';
UPDATE location_type_master SET level = 3 WHERE type = 'B';
UPDATE location_type_master SET level = 2 WHERE type = 'C';
UPDATE location_type_master SET level = 2 WHERE type = 'D';
UPDATE location_type_master SET level = 4 WHERE type = 'P';
UPDATE location_type_master SET level = 1 WHERE type = 'S';
UPDATE location_type_master SET level = 5 WHERE type = 'SC';
UPDATE location_type_master SET level = 4 WHERE type = 'U';
UPDATE location_type_master SET level = 5 WHERE type = 'UA';
UPDATE location_type_master SET level = 6 WHERE type = 'V';
UPDATE location_type_master SET level = 3 WHERE type = 'Z';