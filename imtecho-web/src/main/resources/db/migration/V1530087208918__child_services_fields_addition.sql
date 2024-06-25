ALTER TABLE rch_child_service_master
DROP COLUMN IF EXISTS member_status,
ADD COLUMN member_status character varying(15);