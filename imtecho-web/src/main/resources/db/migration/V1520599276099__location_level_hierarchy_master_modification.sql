ALTER TABLE location_level_hierarchy_master ALTER COLUMN id TYPE bigint;

ALTER TABLE location_master ALTER COLUMN name TYPE varchar(4000);

ALTER TABLE location_master ALTER COLUMN type TYPE varchar(10);

ALTER TABLE location_level_hierarchy_master ALTER COLUMN location_id TYPE bigint;

ALTER TABLE location_level_hierarchy_master ALTER COLUMN level1 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level2 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level3 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level4 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level5 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level6 TYPE bigint;
ALTER TABLE location_level_hierarchy_master ALTER COLUMN level7 TYPE bigint;


---System configuration insert--
delete from system_configuration where system_key = 'ALLOWED_CHARACTERS_IN_ERROR_LOG';
INSERT INTO system_configuration(system_key, is_active, key_value) VALUES ('ALLOWED_CHARACTERS_IN_ERROR_LOG', TRUE, 150);

DO $$ 
    BEGIN
        BEGIN
        
	ALTER TABLE location_level_hierarchy_master ADD COLUMN location_type character varying(50);
EXCEPTION
        
            WHEN duplicate_column THEN 
            
            RAISE NOTICE 'Already exists';
 END;
    END;
$$;
