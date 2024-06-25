ALTER TABLE notification_type_master 
DROP COLUMN IF EXISTS is_location_filter_required,
DROP COLUMN IF EXISTS fetch_up_to_level,
DROP COLUMN IF EXISTS required_up_to_level,
DROP COLUMN IF EXISTS is_fetch_according_aoi;

ALTER TABLE notification_type_master 
ADD COLUMN is_location_filter_required boolean DEFAULT false,
ADD COLUMN fetch_up_to_level int,
ADD COLUMN required_up_to_level int,
ADD COLUMN is_fetch_according_aoi boolean DEFAULT true;
	