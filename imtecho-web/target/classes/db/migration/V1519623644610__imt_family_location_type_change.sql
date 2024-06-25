ALTER TABLE imt_family
 ADD COLUMN old_location_id character varying(256);

update imt_family set old_location_id = location_id;

ALTER TABLE imt_family
 Drop COLUMN location_id;

ALTER TABLE imt_family
 ADD COLUMN location_id bigint;

update imt_family set location_id = old_location_id::bigint where old_location_id != 'null';

ALTER TABLE imt_family
 Drop COLUMN old_location_id;