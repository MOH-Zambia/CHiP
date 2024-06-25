ALTER TABLE rch_lmp_follow_up
DROP COLUMN IF EXISTS member_status,
ADD COLUMN member_status character varying(15),
DROP COLUMN IF EXISTS death_date,
ADD COLUMN death_date timestamp without time zone,
DROP COLUMN IF EXISTS death_reason,
ADD COLUMN death_reason character varying(50);