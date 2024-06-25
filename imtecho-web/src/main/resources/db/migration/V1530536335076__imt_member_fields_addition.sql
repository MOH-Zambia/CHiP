ALTER TABLE imt_member
DROP COLUMN IF EXISTS anc_visit_dates,
ADD COLUMN anc_visit_dates text,
DROP COLUMN IF EXISTS immunisation_given,
ADD COLUMN immunisation_given text;