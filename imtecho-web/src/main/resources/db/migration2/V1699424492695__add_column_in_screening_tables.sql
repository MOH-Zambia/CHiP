alter table rch_preg_hiv_positive_master
drop column if exists is_referral_done,
add column if not exists is_referral_done text;

alter table tuberculosis_screening_details
drop column if exists fu_referral_place,
add column if not exists is_referral_done text;

alter table malaria_details
add column if not exists is_referral_done text;