ALTER TABLE user_installed_apps
ADD COLUMN  created_by bigint,
ADD COLUMN  created_on timestamp without time zone,
ADD COLUMN  modified_by bigint,
ADD COLUMN  modified_on timestamp without time zone;