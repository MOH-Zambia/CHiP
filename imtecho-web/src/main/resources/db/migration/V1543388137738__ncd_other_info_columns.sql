ALTER TABLE public.ncd_member_other_information
  ADD COLUMN created_by bigint;
ALTER TABLE public.ncd_member_other_information
  ADD COLUMN created_on timestamp without time zone;
ALTER TABLE public.ncd_member_other_information
  ADD COLUMN modified_by bigint;
ALTER TABLE public.ncd_member_other_information
  ADD COLUMN modified_on timestamp without time zone;