ALTER TABLE public.imt_family
  ADD COLUMN merged_with character varying(50);
ALTER TABLE public.imt_member
  ADD COLUMN merged_from_family_id character varying(50);