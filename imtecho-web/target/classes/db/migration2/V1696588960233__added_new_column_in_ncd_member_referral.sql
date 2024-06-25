--ADDED NEW COLUMN IN ncd_member_referral TABLE
alter table ncd_member_referral
add column if not exists pvt_health_infra_name text;