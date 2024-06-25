ALTER TABLE rch_wpd_mother_master
DROP COLUMN IF EXISTS mtp_done_at,
ADD COLUMN mtp_done_at bigint,
DROP COLUMN IF EXISTS mtp_performed_by,
ADD COLUMN mtp_performed_by character varying(15);