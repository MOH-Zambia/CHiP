-- For issue https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2332
-- Add columns in rch_anc_master


ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS examined_by_gynecologist,
ADD COLUMN examined_by_gynecologist boolean;


ALTER TABLE rch_anc_master
DROP COLUMN IF EXISTS is_inj_corticosteroid_given,
ADD COLUMN is_inj_corticosteroid_given boolean;