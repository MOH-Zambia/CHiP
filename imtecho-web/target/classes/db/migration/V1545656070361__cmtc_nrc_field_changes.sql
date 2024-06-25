alter table child_cmtc_nrc_weight_detail
drop column if exists mid_upper_arm_circumference,
drop column if exists height,
drop column if exists higher_facility_referral,
drop column if exists referral_reason,
add column mid_upper_arm_circumference integer,
add column height integer,
add column higher_facility_referral text,
add column referral_reason text;

alter table child_cmtc_nrc_follow_up
drop column if exists other_cmtc_center_follow_up,
add column other_cmtc_center_follow_up boolean;

alter table child_cmtc_nrc_screening_detail
drop column if exists mo_not_verified,
add column mo_not_verified boolean;

alter table child_cmtc_nrc_admission_detail
drop column if exists urine_creatinine,
drop column if exists urine_pus_cells,
drop column if exists urine_pus_cells_count,
drop column if exists urine_rm,
drop column if exists urine_albumin,
add column urine_rm text,
add column urine_albumin text;