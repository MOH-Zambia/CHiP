ALTER TABLE child_nutrition_sam_screening_master
ADD COLUMN IF NOT EXISTS child_state text,
ADD COLUMN IF NOT EXISTS has_initial_treatment_started boolean;

ALTER TABLE child_cmtc_nrc_screening_detail
ADD COLUMN IF NOT EXISTS discard_date date;