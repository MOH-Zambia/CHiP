ALTER TABLE imt_member 
DROP COLUMN IF EXISTS child_nrc_cmtc_status, 
ADD COLUMN child_nrc_cmtc_status text;