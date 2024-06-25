ALTER TABLE public.ncd_member_other_information
  ADD COLUMN smoke_tobacco boolean;

ALTER TABLE public.ncd_member_other_information
  ADD COLUMN smokeless_tobacco boolean;

ALTER TABLE public.ncd_member_other_information
  ADD COLUMN alcohol_consumption character varying (200);

ALTER TABLE public.ncd_member_oral_detail
  ADD COLUMN other_symptoms character varying (1000);

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN other_symptoms character varying (1000);


ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN skin_dimpling boolean;
  
ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN ulceration boolean ;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN is_retraction_of_skin boolean;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN nipples_not_on_same_level boolean;
  
ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN is_axillary boolean;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN  is_super_clavicular_area boolean;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN  is_infra_clavicular_area boolean;
 
