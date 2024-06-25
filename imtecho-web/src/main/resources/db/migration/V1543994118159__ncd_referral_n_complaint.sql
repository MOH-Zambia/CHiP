ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN retraction_of_skin text;
ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN discharge_from_nipples text;


ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN sensory_loss boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN regular_rythm_cardio boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN any_injuries boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN edema boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN prominent_veins boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN gangrene_feet boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN ulcers_feet boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN calluses_feet boolean;
ALTER TABLE public.ncd_member_diabetes_detail
  ADD COLUMN peripheral_pulses boolean;


ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN is_regular_rythm boolean;
ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN murmur boolean;
ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN bilateral_clear boolean;
ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN bilateral_basal_crepitation boolean;
ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN rhonchi boolean;




CREATE TABLE public.ncd_member_complaints
(
   id bigserial, 
   member_id bigint, 
   complaint character varying(1000), 
   created_by bigint,
   created_on timestamp without time zone,
   modifiedby bigint,
   modified_on timestamp without time zone,

CONSTRAINT ncd_member_complaints_pkey PRIMARY KEY (id)

) 
WITH (
  OIDS = FALSE
);

CREATE TABLE public.ncd_member_provisional_diagnosis
(
   id bigserial, 
   member_id bigint, 
   diagnosis character varying(1000), 
   created_by bigint,
   created_on timestamp without time zone,
   modifiedby bigint,
   modified_on timestamp without time zone,

CONSTRAINT ncd_member_provisional_diagnosis_pkey PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
);

CREATE TABLE public.ncd_member_referral
(
    id bigserial,
   referred_by bigint, 
   referred_to character varying, 
   referred_on timestamp without time zone, 
   disease_code character varying(100), 
   location_id bigint, 
   member_id bigint,
created_by bigint,
   created_on timestamp without time zone,
   modifiedby bigint,
   modified_on timestamp without time zone,
CONSTRAINT ncd_member_referral_pkey PRIMARY KEY (id)
) 
WITH (
  OIDS = FALSE
)
;





