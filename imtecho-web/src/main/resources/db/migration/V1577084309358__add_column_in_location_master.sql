
-- For issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2776

ALTER TABLE location_master
DROP COLUMN IF EXISTS is_taaho,
ADD COLUMN is_taaho boolean;