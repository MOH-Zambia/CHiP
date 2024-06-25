
-- Mobile form version
update system_configuration set key_value = '20' where system_key = 'MOBILE_FORM_VERSION';


-- create table
DROP TABLE IF EXISTS public.ncd_diabetes_confirmation_detail;
CREATE TABLE public.ncd_diabetes_confirmation_detail
(
  id bigserial,
  member_id bigint NOT NULL,
  location_id integer,
  family_id integer,
  created_by bigint,
  created_on timestamp without time zone,
  modified_by bigint,
  modified_on timestamp without time zone,
  latitude character varying(100),
  longitude character varying(100),
  mobile_start_date timestamp without time zone NOT NULL,
  mobile_end_date timestamp without time zone NOT NULL,
  screening_date timestamp without time zone,
  fasting_blood_sugar integer,
  post_prandial_blood_sugar integer,
  flag boolean,
  done_by character varying(200),
  done_on timestamp without time zone,
  CONSTRAINT ncd_member_diabetes_detail_pkey PRIMARY KEY (id)
);

-- create health screening table
DROP TABLE IF EXISTS public.ncd_member_health_detail;
CREATE TABLE public.ncd_member_health_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    family_id integer,
    location_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    is_provided_consent boolean,
    weight numeric(6,2),
    height integer,
    bmi numeric(6,2),
    waist integer,
    disease_history character varying (200),
    other_disease text,
    risk_factor character varying (200),
    done_by character varying (200),
    done_on timestamp without time zone
);

Drop table if exists public.ncd_personal_history;
CREATE TABLE IF NOT EXISTS public.ncd_personal_history
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	family_id integer,
	location_id integer,
    service_date timestamp without time zone NOT NULL,
    age_at_menarche integer,
    menopause_arrived boolean,
    duration_of_menopause integer,
    pregnant boolean,
    lactating boolean,
    regular_periods boolean,
    lmp timestamp without time zone,
    bleeding text COLLATE pg_catalog."default",
    associated_with text COLLATE pg_catalog."default",
    remarks text COLLATE pg_catalog."default",
    diagnosed_for_hypertension boolean,
    under_treatement_for_hypertension boolean,
    diagnosed_for_diabetes boolean,
    under_treatement_for_diabetes boolean,
    diagnosed_for_heart_diseases boolean,
    under_treatement_for_heart_diseases boolean,
    diagnosed_for_stroke boolean,
    under_treatement_for_stroke boolean,
    diagnosed_for_kidney_failure boolean,
    under_treatement_for_kidney_failure boolean,
    diagnosed_for_non_healing_wound boolean,
    under_treatement_for_non_healing_wound boolean,
    diagnosed_for_copd boolean,
    under_treatement_for_copd boolean,
    diagnosed_for_asthama boolean,
    under_treatement_for_asthama boolean,
    diagnosed_for_oral_cancer boolean,
    under_treatement_for_oral_cancer boolean,
    diagnosed_for_breast_cancer boolean,
    under_treatement_for_breast_cancer boolean,
    diagnosed_for_cervical_cancer boolean,
    under_treatement_for_cervical_cancer boolean,
	any_other_examination boolean,
	specify_other_examination text,
    height integer,
    weight numeric(6,2),
    bmi numeric(8,2),
	created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default"
);


-- Alter existing tables
ALTER TABLE imt_family
 ADD COLUMN IF NOT EXISTS other_type_of_house character varying(256);

 ALTER TABLE imt_member
 ADD COLUMN IF NOT EXISTS health_insurance boolean;
 ALTER TABLE imt_member
 ADD COLUMN IF NOT EXISTS scheme_detail character varying(256);
 ALTER TABLE imt_member
 ADD COLUMN IF NOT EXISTS is_personal_history_done boolean;


 ALTER TABLE ncd_member_oral_detail
 ADD COLUMN IF NOT EXISTS symptoms_remarks text,
 ADD COLUMN IF NOT EXISTS white_or_red_patch Boolean,
 ADD COLUMN IF NOT EXISTS ulceration_roughened_areas Boolean,
 ADD COLUMN IF NOT EXISTS is_red_patch boolean;


 ALTER TABLE ncd_member_cervical_detail
 ADD COLUMN IF NOT EXISTS trained_via_examination boolean,
 ADD COLUMN IF NOT EXISTS excessive_discharge boolean,
 ADD COLUMN IF NOT EXISTS visual_polyp text,
 ADD COLUMN IF NOT EXISTS visual_ectopy text,
 ADD COLUMN IF NOT EXISTS visual_hypertrophy text,
 ADD COLUMN IF NOT EXISTS visual_bleeds_on_touch text,
 ADD COLUMN IF NOT EXISTS visual_unhealthy_cervix text,
 ADD COLUMN IF NOT EXISTS visual_suspicious_looking text,
 ADD COLUMN IF NOT EXISTS visual_frank_growth text,
 ADD COLUMN IF NOT EXISTS visual_prolapse_uterus text;


 ALTER TABLE ncd_member_breast_detail
 ADD COLUMN IF NOT EXISTS swelling_or_lump Boolean,
 ADD COLUMN IF NOT EXISTS puckering_or_dimpling Boolean,
 ADD COLUMN IF NOT EXISTS constant_pain_in_breast Boolean;

 ALTER TABLE ncd_member_breast_detail
 RENAME COLUMN visual_discharge_from_nipple TO discharge_from_nipple_flag;

 ALTER TABLE ncd_member_breast_detail
 RENAME COLUMN visual_swelling_in_armpit TO swelling_in_armpit_flag;


 ALTER TABLE ncd_member_breast_detail
 ADD COLUMN IF NOT EXISTS skin_dimpling_retraction_flag boolean,
 ADD COLUMN IF NOT EXISTS nipple_retraction_distortion_flag boolean,
 ADD COLUMN IF NOT EXISTS lump_in_breast_flag boolean,
 ADD COLUMN IF NOT EXISTS visual_discharge_from_nipple text,
 ADD COLUMN IF NOT EXISTS visual_swelling_in_armpit text;

 ALTER TABLE ncd_member_cbac_detail
 ADD COLUMN IF NOT EXISTS recurrent_ulceration boolean,
 ADD COLUMN IF NOT EXISTS recurrent_tingling boolean,
 ADD COLUMN IF NOT EXISTS cloudy_vision boolean,
 ADD COLUMN IF NOT EXISTS reading_difficluty boolean,
 ADD COLUMN IF NOT EXISTS eye_pain boolean,
 ADD COLUMN IF NOT EXISTS eye_redness boolean,
 ADD COLUMN IF NOT EXISTS hearing_difficulty boolean,
 ADD COLUMN IF NOT EXISTS chewing_pain boolean,
 ADD COLUMN IF NOT EXISTS mouth_ulcers boolean,
 ADD COLUMN IF NOT EXISTS mouth_patch boolean,
 ADD COLUMN IF NOT EXISTS thick_skin boolean,
 ADD COLUMN IF NOT EXISTS nodules_on_skin boolean,
 ADD COLUMN IF NOT EXISTS tingling_in_hand boolean,
 ADD COLUMN IF NOT EXISTS inability_close_eyelid boolean,
 ADD COLUMN IF NOT EXISTS feet_weakness boolean,
 ADD COLUMN IF NOT EXISTS crop_residue_burning boolean,
 ADD COLUMN IF NOT EXISTS garbage_burning boolean,
 ADD COLUMN IF NOT EXISTS working_industry boolean,
 ADD COLUMN IF NOT EXISTS interest_doing_things boolean,
 ADD COLUMN IF NOT EXISTS feeling_down text,
 ADD COLUMN IF NOT EXISTS clawing_of_fingers boolean;


 ALTER TABLE ncd_member_cbac_detail
  ALTER COLUMN interest_doing_things TYPE text;


-- Add new forms and new Feature

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_FHW_HEALTH_SCREENING', 'NCD_FHW_HEALTH_SCREENING', now(), -1, now(), -1);

insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW') and mfd.form_name = 'NCD_FHW_HEALTH_SCREENING';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_FHW_HEALTH_SCREENING' and mffr.mobile_constant = 'FHW_NCD_SCREENING';


INSERT INTO public.mobile_form_details(
	 form_name, file_name, created_on, created_by, modified_on, modified_by)
	VALUES ('NCD_PERSONAL_HISTORY', 'NCD_PERSONAL_HISTORY', now(), -1, now(), -1);

INSERT INTO public.mobile_form_feature_rel(
	form_id, mobile_constant)
	VALUES ((select id from mobile_form_details where form_name = 'NCD_PERSONAL_HISTORY'),'FHW_NCD_SCREENING' );



insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values
('FHW_NCD_CONFIRMATION', 'FHW NCD Confirmation', 'NCD Confirmation', 'ACTIVE', now(), -1, now(), -1);

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_FHW_DIABETES_CONFIRMATION', 'NCD_FHW_DIABETES_CONFIRMATION', now(), -1, now(), -1);

insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW') and mfd.form_name = 'NCD_FHW_DIABETES_CONFIRMATION';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_FHW_DIABETES_CONFIRMATION' and mffr.mobile_constant = 'FHW_NCD_CONFIRMATION';


-- Query Builder Query
DELETE FROM QUERY_MASTER WHERE CODE='mob_ncd_cbac_details_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'35ffa425-7273-4130-8e27-c5f2df8f7415', 57698,  current_date , 57698,  current_date , 'mob_ncd_cbac_details_by_member_id',
'memberId',
'with max_record as (
	select max(id) as ncd_id from ncd_member_cbac_detail where member_id = #memberId#
)select imt_member.unique_health_id as "uniqueHealthId",
cast(imt_member.id as text) as "memberId",
imt_member.family_id as "familyId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.dob,
cast(age(imt_member.dob) as text) as "age",
imt_member.gender as "gender",
concat(imt_family.address1,'' '',imt_family.address2) as "address",
cast(imt_family.id as text) as "fid",
imt_member.mobile_number as "mobileNumber",
ncd_member_cbac_detail.* from ncd_member_cbac_detail
inner join imt_member on ncd_member_cbac_detail.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
where ncd_member_cbac_detail.id in (select ncd_id from max_record)',
'CBAC Online Viewing Data Query',
true, 'ACTIVE');



DELETE FROM QUERY_MASTER WHERE CODE='mob_ncd_personal_history_details_by_member_id';

INSERT INTO QUERY_MASTER (uuid, created_by, created_on, modified_by, modified_on, code, params, query, description, returns_result_set, state )
VALUES (
'6836b1b5-cd9c-42f3-bac2-839d631962fb', 97070,  current_date , 97070,  current_date , 'mob_ncd_personal_history_details_by_member_id',
'memberId',
'with max_record as (
	select max(id) as ncd_id from ncd_personal_history where member_id = #memberId#
)select imt_member.unique_health_id as "uniqueHealthId",
cast(imt_member.id as text) as "memberId",
imt_member.family_id as "familyId",
concat(imt_member.first_name,'' '',imt_member.middle_name,'' '',imt_member.last_name) as "memberName",
imt_member.dob,
cast(age(imt_member.dob) as text) as "age",
imt_member.gender as "gender",
concat(imt_family.address1,'' '',imt_family.address2) as "address",
cast(imt_family.id as text) as "fid",
imt_member.mobile_number as "mobileNumber",
imt_member.health_insurance as "healthInsurance",
imt_member.scheme_detail as "schemeDetail",
(select value from listvalue_field_value_detail where id = imt_member.education_status) as "educationStatusValue",
ncd_personal_history.* from ncd_personal_history
inner join imt_member on ncd_personal_history.member_id = imt_member.id
inner join imt_family on imt_member.family_id = imt_family.family_id
where ncd_personal_history.id in (select ncd_id from max_record)',
'Personal History Online Viewing Data Query',
true, 'ACTIVE');



