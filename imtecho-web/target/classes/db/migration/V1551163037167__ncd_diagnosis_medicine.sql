drop table if exists ncd_member_diseases_diagnosis;

CREATE TABLE public.ncd_member_diseases_diagnosis
(
   member_id bigint, 
   diagnosis text, 
   remarks text, 
   disease_code character varying(50), 
   created_by bigint, 
   created_on timestamp without time zone, 
   modified_by bigint, 
   modified_on timestamp without time zone, 
   id bigserial
) 
WITH (
  OIDS = FALSE
)
;

drop table if exists ncd_member_disesase_medicine;

CREATE TABLE public.ncd_member_disesase_medicine
(
   id bigserial, 
   member_id bigint, 
   medicine_id bigint, 
   disease_code character varying(50), 
   created_by bigint, 
   created_on timestamp without time zone, 
   modified_on timestamp without time zone, 
   modified_by bigint
) 
WITH (
  OIDS = FALSE
)
;
drop table if exists ncd_member_disesase_followup;

CREATE TABLE public.ncd_member_disesase_followup
(
   id bigserial, 
   member_id bigint, 
   followup_date timestamp without time zone, 
   disease_code character varying(50), 
   created_by bigint, 
   created_on timestamp without time zone, 
   modified_on timestamp without time zone, 
   modified_by bigint
) 
WITH (
  OIDS = FALSE
)
;

drop table if exists medicine_master;

CREATE TABLE public.medicine_master
(
   id bigserial, 
   name character varying(1000), 
   created_by bigint, 
   created_on timestamp without time zone, 
   modified_by bigint, 
   modified_on timestamp without time zone
) 
WITH (
  OIDS = FALSE
)
;

-- drop table if exists ncd_member_disesase_referral;
-- 
-- CREATE TABLE public.ncd_member_disesase_referral
-- (
--   id bigserial,
--   referred_by bigint,
--   referred_from character varying(500),
--   referred_to character varying(500),
--   referred_on timestamp without time zone,
--   disease_code character varying(100),
--   location_id bigint,
--   member_id bigint,
--   created_by bigint,
--   created_on timestamp without time zone,
--   modified_by bigint,
--   modified_on timestamp without time zone,
--   CONSTRAINT ncd_member_referral_primarykey PRIMARY KEY (id)
-- ) 
-- WITH (
--   OIDS = FALSE
-- )
-- ;

ALTER TABLE public.ncd_member_diseases_diagnosis
  ADD COLUMN diagnosed_on timestamp without time zone;
ALTER TABLE public.ncd_member_disesase_medicine
  ADD COLUMN diagnosed_on timestamp without time zone;

ALTER TABLE public.ncd_member_referral
  ADD COLUMN referred_from character varying;
ALTER TABLE public.ncd_member_referral
  ADD COLUMN remarks character varying;

ALTER TABLE public.ncd_member_breast_detail
  ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_cbac_detail  
  ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_cervical_detail    
  ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_complaints    
  ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_diabetes_detail    
  ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_hypertension_detail   
  ADD COLUMN referral_id bigint;
  ALTER TABLE public.ncd_member_oral_detail 
  ADD COLUMN referral_id bigint;
  ALTER TABLE public.ncd_member_other_information  
  ADD COLUMN referral_id bigint;
  ALTER TABLE public.ncd_member_provisional_diagnosis  
  ADD COLUMN referral_id bigint;
  ALTER TABLE public.ncd_member_diseases_diagnosis  
  ADD COLUMN referral_id bigint;
  ALTER TABLE public.ncd_member_disesase_followup  
ADD COLUMN referral_id bigint;
ALTER TABLE public.ncd_member_disesase_medicine  
  ADD COLUMN referral_id bigint;

ALTER TABLE public.ncd_member_referral RENAME remarks  TO reason;

ALTER TABLE public.ncd_member_disesase_followup
  ADD COLUMN referral_from character varying;

update menu_config
set navigation_state='techi.ncd.members({''type'':''PHC''})'
where navigation_state='techo.ncd.members';


insert into menu_config (feature_json,active,menu_name,navigation_state,menu_type)
values('{}',true,'CHC Referred Patients','techo.ncd.members({type:''CHC''})','ncd');

    