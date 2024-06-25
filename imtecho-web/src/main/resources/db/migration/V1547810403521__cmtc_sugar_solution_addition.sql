alter table child_cmtc_nrc_weight_detail
drop column if exists is_sugar_solution,
add column is_sugar_solution boolean;