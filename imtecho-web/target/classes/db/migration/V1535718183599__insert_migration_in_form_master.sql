INSERT into form_master (created_by, created_on, modified_by, modified_on, code, name, state)
VALUES(1, now(), 1, now(), 'MIGRATION', 'MIGRATION', 'ACTIVE');

ALTER TABLE migration_master 
DROP COLUMN if exists family_migrated_from, 
ADD COLUMN family_migrated_from character varying(20);

ALTER TABLE migration_master 
DROP COLUMN if exists family_migrated_to, 
ADD COLUMN family_migrated_to character varying(20);