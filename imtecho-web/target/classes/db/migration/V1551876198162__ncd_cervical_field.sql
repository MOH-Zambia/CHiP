ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN papsmear_test boolean;

ALTER TABLE public.ncd_member_diseases_diagnosis
  ADD COLUMN readings character varying;