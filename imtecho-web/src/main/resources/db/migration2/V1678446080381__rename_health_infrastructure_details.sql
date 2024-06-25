alter table health_infrastructure_details
drop column if exists hfr_facility_id,
add column hfr_facility_id character varying(200),
DROP COLUMN IF EXISTS is_link_to_bridge_id,
ADD COLUMN is_link_to_bridge_id boolean DEFAULT false;

ALTER TABLE health_infrastructure_details
ADD CONSTRAINT unique_hfr_facility_id UNIQUE (hfr_facility_id);