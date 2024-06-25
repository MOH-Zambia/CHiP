alter table imt_member
add column if not exists birth_cert_number text;

alter table malaria_details
add column if not exists is_index_case boolean;

alter table rch_hiv_screening_master
add column if not exists referral_place integer;