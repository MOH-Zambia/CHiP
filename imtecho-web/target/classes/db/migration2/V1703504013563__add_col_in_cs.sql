alter table rch_child_service_master
add column if not exists referral_place integer,
add column if not exists referral_for text,
add column if not exists referral_reason text,
add column if not exists delay_in_developmental boolean,
add column if not exists any_disability text,
add column if not exists other_disability text;