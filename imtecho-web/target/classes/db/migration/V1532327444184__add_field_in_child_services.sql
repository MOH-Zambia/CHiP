ALTER TABLE rch_child_service_master
DROP COLUMN IF EXISTS any_vaccination_pending,
ADD COLUMN any_vaccination_pending boolean;