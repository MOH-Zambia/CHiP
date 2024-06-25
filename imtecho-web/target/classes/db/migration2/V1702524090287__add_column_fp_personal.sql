alter table imt_member
add column if not exists personally_using_fp boolean;

alter table rch_member_death_deatil
add column if not exists other_death_place text;

alter table malaria_details
add column if not exists referral_for text;

alter table tuberculosis_screening_details
add column if not exists referral_for text;

alter table covid_screening_details
add column if not exists referral_for text;

alter table rch_anc_master
add column if not exists referral_for text,
add column if not exists other_death_place text;

alter table rch_pnc_mother_master
add column if not exists referral_for text,
add column if not exists other_death_place text;

alter table rch_pnc_child_master
add column if not exists referral_for text,
add column if not exists other_death_place text;

alter table rch_wpd_mother_master
add column if not exists referral_for text,
add column if not exists other_death_place text;

alter table rch_wpd_child_master
add column if not exists referral_for text;

alter table rch_child_service_master
add column if not exists other_death_place text;

alter table rch_lmp_follow_up
add column if not exists other_death_place text;

alter table rch_preg_hiv_positive_master
add column if not exists referral_for text;





