alter table child_cmtc_nrc_discharge_detail
drop column if exists admission_id,
add column admission_id bigint;

UPDATE child_cmtc_nrc_discharge_detail
SET    admission_id = child_cmtc_nrc_screening_detail.admission_id 
FROM   child_cmtc_nrc_screening_detail
WHERE  child_cmtc_nrc_discharge_detail.id = child_cmtc_nrc_screening_detail.discharge_id;