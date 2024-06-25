alter table child_cmtc_nrc_admission_detail
drop column if exists complementary_feeding,
drop column if exists breast_feeding,
add column complementary_feeding boolean,
add column breast_feeding boolean;

alter table child_cmtc_nrc_weight_detail
drop column if exists night_stay,
add column night_stay boolean;