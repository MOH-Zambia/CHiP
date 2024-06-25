alter table covid_screening_details
add column if not exists reation_and_effects text,
add column if not exists other_effects text,
add column if not exists is_referral_done text,
add column if not exists referral_reason text,
add column if not exists referral_place integer;

