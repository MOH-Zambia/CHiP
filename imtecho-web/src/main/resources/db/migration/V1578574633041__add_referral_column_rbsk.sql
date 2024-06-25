ALTER table rbsk_head_to_toe_screening
drop column if exists referral_done,
ADD COLUMN referral_done boolean,
drop column if exists referral_place,
ADD COLUMN referral_place bigint;