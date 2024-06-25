ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS hypertension_screening_done,
ADD COLUMN hypertension_screening_done boolean;

ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS oral_screening_done,
ADD COLUMN oral_screening_done boolean;

ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS diabetes_screening_done,
ADD COLUMN diabetes_screening_done boolean;

ALTER TABLE public.imt_member
DROP COLUMN IF EXISTS breast_screening_done,
ADD COLUMN breast_screening_done boolean;