ALTER TABLE npcb_member_screening_master
DROP COLUMN IF EXISTS service_date,
ADD COLUMN service_date date,
DROP COLUMN IF EXISTS notification_id,
ADD COLUMN notification_id bigint;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS npcb_screening_date,
ADD COLUMN npcb_screening_date date;