alter table child_cmtc_nrc_screening_detail
drop column if exists is_direct_admission,
add column is_direct_admission boolean;

alter table child_cmtc_nrc_weight_detail
drop column if exists mother_councelling_days;