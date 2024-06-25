alter table child_cmtc_nrc_screening_detail
drop column if exists is_dead,
add column is_dead boolean;