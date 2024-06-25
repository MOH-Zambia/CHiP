ALTER TABLE rch_asha_pnc_master
DROP COLUMN IF EXISTS member_status,
ADD COLUMN member_status text;