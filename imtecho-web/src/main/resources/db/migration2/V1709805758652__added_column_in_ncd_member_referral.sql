--ADDED NEW COLUMN IN ncd_member_referral TABLE
ALTER TABLE ncd_member_referral
ADD IF NOT EXISTS mo_referred_health_infra_type varchar(15);