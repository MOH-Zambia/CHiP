alter table emtct_details
add column if not exists referral_place int4 null,
add column if not exists is_referral_done text null,
add column if not exists referral_reason text null,
add column if not exists referral_for text null,
add column if not exists is_iec_given bool null;

alter table rch_hiv_known_master
add column if not exists referral_place int4 null,
add column if not exists is_referral_done text null,
add column if not exists referral_reason text null,
add column if not exists referral_for text null,
add column if not exists is_iec_given bool null;

alter table gbv_visit_master
add column if not exists referral_place int4 null,
add column if not exists is_referral_done text null,
add column if not exists referral_reason text null,
add column if not exists referral_for text null,
add column if not exists is_iec_given bool null;


alter table malaria_index_case_details
add column if not exists referral_place int4 null,
add column if not exists is_referral_done text null,
add column if not exists referral_reason text null,
add column if not exists referral_for text null,
add column if not exists is_iec_given bool null;


alter table malaria_non_index_case_details
add column if not exists referral_place int4 null,
add column if not exists is_referral_done text null,
add column if not exists referral_reason text null,
add column if not exists referral_for text null,
add column if not exists is_iec_given bool null;


update system_configuration set key_value = '123' where system_key = 'MOBILE_FORM_VERSION';

