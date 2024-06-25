ALTER TABLE mobile_library_master DROP COLUMN IF EXISTS state;
ALTER TABLE mobile_library_master ADD COLUMN state varchar default 'ACTIVE';
ALTER TABLE mobile_library_master DROP COLUMN IF EXISTS description;
ALTER TABLE mobile_library_master ADD COLUMN description varchar;