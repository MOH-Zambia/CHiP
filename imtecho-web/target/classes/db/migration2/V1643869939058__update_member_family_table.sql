update system_configuration set key_value = '9' where system_key = 'MOBILE_FORM_VERSION';

alter table imt_member
DROP COLUMN IF EXISTS vulnerable_flag,
ADD COLUMN vulnerable_flag boolean;


alter table imt_family
DROP COLUMN IF EXISTS is_providing_consent,
ADD COLUMN is_providing_consent boolean,
DROP COLUMN IF EXISTS vulnerability_criteria,
ADD COLUMN vulnerability_criteria text,
DROP COLUMN IF EXISTS eligible_for_pmjay,
ADD COLUMN eligible_for_pmjay boolean;