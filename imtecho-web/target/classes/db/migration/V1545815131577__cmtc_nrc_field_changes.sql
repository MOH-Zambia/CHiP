alter table child_cmtc_nrc_laboratory_detail
drop column if exists urine_rm_checked,
drop column if exists urine_rm,
drop column if exists urine_pus_cells_checked,
drop column if exists urine_pus_cells,
drop column if exists hiv_checked,
drop column if exists hiv,
drop column if exists sickle_checked,
drop column if exists sickle,
add column urine_pus_cells_checked boolean,
add column urine_pus_cells real,
add column hiv_checked boolean,
add column hiv text,
add column sickle_checked boolean,
add column sickle text;

alter table child_cmtc_nrc_weight_detail
drop column if exists multi_vitamin_syrup,
add column multi_vitamin_syrup boolean;