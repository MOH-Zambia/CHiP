ALTER TABLE child_cmtc_nrc_admission_detail  
ADD COLUMN is_imported boolean;

ALTER TABLE child_cmtc_nrc_screening_detail 
ADD COLUMN is_imported boolean;

ALTER TABLE child_cmtc_nrc_discharge_detail
ADD COLUMN is_imported boolean;

ALTER TABLE child_cmtc_nrc_follow_up
ADD COLUMN is_imported boolean;

ALTER TABLE child_cmtc_nrc_laboratory_detail
ADD COLUMN is_imported boolean;