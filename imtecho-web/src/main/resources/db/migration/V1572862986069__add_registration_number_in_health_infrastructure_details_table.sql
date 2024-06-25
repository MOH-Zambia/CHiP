-- For feature https://argusgit.argusoft.com/mhealth-projects/imtecho/issues/2219

ALTER TABLE health_infrastructure_details
DROP COLUMN IF EXISTS registration_number,
ADD COLUMN registration_number text;
