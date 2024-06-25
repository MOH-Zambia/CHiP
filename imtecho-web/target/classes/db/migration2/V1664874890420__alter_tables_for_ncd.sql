ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS others,
ADD COLUMN others VARCHAR;

ALTER TABLE ncd_member_initial_assessment_detail
DROP COLUMN IF EXISTS weight,
ADD COLUMN weight numeric(6,2);

ALTER TABLE ncd_member_initial_assessment_detail
DROP COLUMN IF EXISTS bmi,
ADD COLUMN bmi numeric(6,2);

ALTER TABLE ncd_member_initial_assessment_detail
DROP COLUMN IF EXISTS refferal_place,
ADD COLUMN refferal_place VARCHAR;