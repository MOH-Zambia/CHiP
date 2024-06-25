alter table child_cmtc_nrc_screening_detail
drop column if exists screening_center,
add column screening_center bigint