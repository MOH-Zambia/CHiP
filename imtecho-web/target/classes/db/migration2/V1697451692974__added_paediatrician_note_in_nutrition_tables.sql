alter table child_cmtc_nrc_admission_detail
add column if not exists paediatrician_note text;

alter table child_cmtc_nrc_weight_detail
add column if not exists paediatrician_note text;