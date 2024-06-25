-- For feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2180

ALTER TABLE ncd_member_referral
DROP COLUMN IF EXISTS referred_from_health_infrastructure_id,
ADD COLUMN referred_from_health_infrastructure_id bigint;