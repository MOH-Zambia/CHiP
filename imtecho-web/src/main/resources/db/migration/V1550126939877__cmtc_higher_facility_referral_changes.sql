alter table child_cmtc_nrc_weight_detail
drop column if exists higher_facility_referral_place,
add column higher_facility_referral_place bigint;

alter table child_cmtc_nrc_discharge_detail
drop column if exists higher_facility_referral_place,
add column higher_facility_referral_place bigint;

alter table child_cmtc_nrc_follow_up
drop column if exists follow_up_other_center,
add column follow_up_other_center bigint;
