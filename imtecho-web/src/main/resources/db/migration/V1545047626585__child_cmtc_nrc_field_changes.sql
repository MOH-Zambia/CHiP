alter table child_cmtc_nrc_admission_detail
drop column if exists lymphocytes,
drop column if exists eosinophil,
drop column if exists rbs,
drop column if exists urine_creatinine,
drop column if exists urine_pus_cells,
drop column if exists urine_pus_cells_count,
drop column if exists esr,
drop column if exists monocytes,
drop column if exists basophils,
drop column if exists urine_glucose,
drop column if exists urine_albumin,
drop column if exists hiv_test;

alter table rch_child_service_master
drop column if exists sd_score,
add column sd_score text;

alter table child_cmtc_nrc_weight_detail
drop column if exists bilateral_pitting_oedema,
drop column if exists child_stay_duration,
add column bilateral_pitting_oedema text;

alter table child_cmtc_nrc_admission_detail
drop column if exists urine_creatinine,
drop column if exists urine_pus_cells,
drop column if exists urine_pus_cells_count,
add column urine_creatinine text,
add column urine_pus_cells text,
add column urine_pus_cells_count real;

alter table child_cmtc_nrc_weight_detail
drop column if exists f_75,
drop column if exists f_100,
drop column if exists epd,
drop column if exists formula_given,
drop column if exists other_higher_nutrients_given,
add column formula_given text,
add column other_higher_nutrients_given boolean;