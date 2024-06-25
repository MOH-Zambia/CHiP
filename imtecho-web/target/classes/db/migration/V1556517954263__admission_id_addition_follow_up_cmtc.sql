alter table child_cmtc_nrc_follow_up 
drop column if exists admission_id,
add column admission_id bigint;

UPDATE child_cmtc_nrc_follow_up
SET    admission_id = child_cmtc_nrc_screening_detail.admission_id 
FROM   child_cmtc_nrc_screening_detail
WHERE  child_cmtc_nrc_follow_up.child_id = child_cmtc_nrc_screening_detail.child_id;