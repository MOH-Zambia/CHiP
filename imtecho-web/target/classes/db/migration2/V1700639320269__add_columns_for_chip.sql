alter table imt_member
drop column if exists passport_number,
add column if not exists passport_number text,
drop column if exists chronic_disease_treatment,
add column if not exists chronic_disease_treatment text,
drop column if exists other_chronic_disease_treatment,
add column if not exists other_chronic_disease_treatment text;


alter table imt_family
drop column if exists waste_disposal_method,
add column waste_disposal_method text;

alter table rch_lmp_follow_up
add column if not exists fp_sub_method text,
add column if not exists fp_alternative_main_method text,
add column if not exists fp_alternative_sub_method text;

alter table imt_member
add column if not exists fp_sub_method text,
add column if not exists fp_alternative_main_method text,
add column if not exists fp_alternative_sub_method text,
add column if not exists member_religion text,
add column if not exists not_using_fp_reason text,
add column if not exists started_menstruating boolean,
add column if not exists fp_stage text;

alter table rch_anc_master
add column if not exists fp_sub_method text,
add column if not exists fp_alternative_main_method text,
add column if not exists fp_alternative_sub_method text,
add column if not exists no_of_preg integer,
add column if not exists any_twin boolean,
add column if not exists any_premature_birth boolean,
add column if not exists referral_reason text;

alter table rch_pnc_mother_master
add column if not exists fp_sub_method text,
add column if not exists fp_alternative_main_method text,
add column if not exists fp_alternative_sub_method text,
add column if not exists referral_reason text;

alter table rch_pnc_child_master
add column if not exists referral_reason text;

alter table malaria_details
add column if not exists started_menstruating boolean,
add column if not exists lmp_date date,
add column if not exists referral_reason text;

alter table tuberculosis_screening_details
add column if not exists started_menstruating boolean,
add column if not exists lmp_date date,
add column if not exists referral_reason text;

alter table rch_wpd_mother_master
add column if not exists referral_reason text;

alter table rch_preg_hiv_positive_master
add column if not exists referral_reason text;