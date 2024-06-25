ALTER TABLE imt_member
DROP COLUMN IF EXISTS kpsy_beneficiary,
ADD COLUMN kpsy_beneficiary boolean;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS iay_beneficiary,
ADD COLUMN iay_beneficiary boolean;

ALTER TABLE imt_member
DROP COLUMN IF EXISTS chiranjeevi_yojna_beneficiary,
ADD COLUMN chiranjeevi_yojna_beneficiary boolean;