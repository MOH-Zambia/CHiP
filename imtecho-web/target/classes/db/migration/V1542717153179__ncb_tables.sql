CREATE TABLE public.ncd_member_other_information
(
   id bigserial,
   member_id bigint NOT NULL,
   excess_thirst boolean, 
   excess_urination boolean, 
   excess_hunger boolean, 
   recurrent_skin boolean, 
   delay_in_healing boolean, 
   change_in_dietery_habits boolean, 
   visual_disturbances_history_or_present boolean, 
   significant_edema boolean, 
   angina boolean, 
   intermittent_claudication boolean, 
   limpness boolean,
   mo_screening_done boolean,
   history_of_stroke boolean,
   history_of_heart_attack boolean,
   family_history_of_diabetes boolean,
   family_history_of_stroke boolean,
   family_history_of_premature_mi boolean,
   is_report_verified boolean,
   confirmed_case_of_copd boolean,
   confirmed_case_of_diabetes boolean,
   confirmed_case_of_hypertension boolean,
   
   
CONSTRAINT ncd_member_other_information_pkey PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
)
;

ALTER TABLE public.ncd_member_oral_detail
  ADD COLUMN restricted_mouth_opening text;

ALTER TABLE public.ncd_member_oral_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_oral_detail
  ADD COLUMN done_on timestamp without time zone;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN consistency_of_lumps character varying(50);
ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN lymphadenopathy boolean;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN done_on timestamp without time zone;


ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN polyp boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN ectopy boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN hypertrophy boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN prolapse_uterus boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN bleeds_on_touch boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN unhealthy_cervix boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN suspicious_looking_cervix boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN frank_malignancy boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN other boolean;
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN other_desc character varying(250);
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN via_exam character varying(200);

ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_cervical_detail
  ADD COLUMN done_on timestamp without time zone;

ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN fasting_blood_sugar integer;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN post_prandial_blood_sugar integer;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN hba1c numeric;

ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN done_on timestamp without time zone;


ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN done_on timestamp without time zone;

ALTER TABLE public.ncd_member_cbac_detail
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_cbac_detail
  ADD COLUMN done_on timestamp without time zone;

ALTER TABLE public.ncd_member_other_information
  ADD COLUMN done_by character varying (200);
ALTER TABLE public.ncd_member_other_information
  ADD COLUMN done_on timestamp without time zone;



/*
    Patient History For confirmed Case of ;
    Previous History
    Family History 
*/
/*
    Master Medical and Medical History
*/