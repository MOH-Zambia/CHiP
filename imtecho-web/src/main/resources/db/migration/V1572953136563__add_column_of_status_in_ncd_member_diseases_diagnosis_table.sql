-- For issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2314

ALTER TABLE ncd_member_diseases_diagnosis
DROP COLUMN IF EXISTS status,
ADD COLUMN status varchar(255);