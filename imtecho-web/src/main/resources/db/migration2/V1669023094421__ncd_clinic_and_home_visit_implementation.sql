
update system_configuration set key_value = '29' where system_key = 'MOBILE_FORM_VERSION';

ALTER TABLE public.ncd_member_hypertension_detail
  ADD COLUMN if not exists weight numeric(6,2),
  ADD COLUMN if not exists  height integer,
  ADD COLUMN if not exists  bmi numeric(6,2),
  ADD COLUMN if not exists  waist integer,
  ADD COLUMN if not exists  disease_history character varying (200),
  ADD COLUMN if not exists  other_disease text,
  ADD COLUMN if not exists  risk_factor character varying (200),
  ADD COLUMN if not exists undertake_physical_activity boolean,
  ADD COLUMN if not exists have_family_history boolean;

ALTER TABLE public.ncd_member_mental_health_detail
  ADD COLUMN if not exists other_problems text;

  ALTER TABLE public.ncd_member_mental_health_detail
  ADD COLUMN if not exists other_diagnosis text;

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Continue tension','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Angry at small things','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Fear or fright','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t like routine work','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Feels can''t do any work','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Can''t concentrate in work','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Think, life is useless','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Suicidal thoughts','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Sleeplessness','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Anorexia','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Breathlessness','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Perspiration','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Weakness in hand and leg','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Palpitation','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Tiredness','mentalHealthObservationList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Does repeated work','mentalHealthObservationList','bchikhly',now(),0);

update listvalue_field_value_detail set is_active = false
where value in ('Presence of behaviour related symptoms',
'Presence of communication related symptoms',
'Presence of feelings related symptoms',
'Presence of sense related symptoms',
'Difficulties in the own work',
'Difficulties in the social work',
'Other-faints, etc.',
'No mental health issues'
) and field_key = 'mentalHealthObservationList';


insert into listvalue_field_form_relation (field, form_id)
select f.field, id
from
mobile_form_details mfm,
(
    values
        ('mentalHealthOtherProblemList')
) f(field)
where mfm.form_name = 'NCD_FHW_MENTAL_HEALTH';

insert into listvalue_field_master (field_key,field,is_active,field_type,form,role_type)
values ('mentalHealthOtherProblemList','mentalHealthOtherProblemList',true,'T','NCD','A,F');


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Fight with people','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Stays alone and don''t speak with anyone','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Continue roaming around','mentalHealthOtherProblemList','bchikhly',now(),0);


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Hurts himself or others','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Speak continuously without any reason','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Talk a lot about having illogical important plans','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Illogical talks','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Illogical expenses','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Laughs illogically','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Cry illogically','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Suicidal thoughts','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Angry at small things','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Hear unreal voices','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Looks at the things which are not present actually','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t bath/clean','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t ask for the food','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Remains unclean always','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Can''t change clothes themselves','mentalHealthOtherProblemList','bchikhly',now(),0);


insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t do job or routine work','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Fight with relatives','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Doubt without any reason','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Don''t visit any social visits','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Epilepsy','mentalHealthOtherProblemList','bchikhly',now(),0);

insert into listvalue_field_value_detail (is_active,is_archive,value,field_key,last_modified_by,last_modified_on,file_size)
values (true,false,'Mental retardation','mentalHealthOtherProblemList','bchikhly',now(),0);


insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values
('FHW_NCD_WEEKLY_VISIT', 'FHW NCD Weekly Vist', 'NCD Weekly Vist', 'ACTIVE', now(), -1, now(), -1);

insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_FHW_WEEKLY_CLINIC', 'NCD_FHW_WEEKLY_CLINIC', now(), -1, now(), -1);

insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW') and mfd.form_name = 'NCD_FHW_WEEKLY_CLINIC';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_FHW_WEEKLY_CLINIC' and mffr.mobile_constant = 'FHW_NCD_WEEKLY_VISIT';


DROP TABLE IF EXISTS public.ncd_member_clinic_visit_detail;
CREATE TABLE public.ncd_member_clinic_visit_detail
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
    clinic_date timestamp without time zone,
    clinic_type character varying(200),
    systolic_bp integer,
    diastolic_bp integer,
    pulse_rate integer,
    hypertension_result character varying(200),
    mental_health_result character varying(200),
    diabetes_result character varying(200),
    talk integer,
    own_daily_work integer,
    social_work integer,
    understanding integer,
    blood_sugar integer,
    patient_taking_medicine boolean,
    required_reference boolean,
    reference_reason text,
    referral_place character varying(200),
    refer_status character varying(200),
    flag boolean,
    flag_reason character varying(200),
    other_reason text,
    followup_visit_type character varying(200),
    followup_date timestamp without time zone,
    remarks text,
    done_by character varying (200),
    done_on timestamp without time zone
);


INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'NCD_CLINIC_VISIT','NCD Clinic Visit','MO',30,'ACTIVE');


INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'NCD_HOME_VISIT','NCD Home Visit','MO',30,'ACTIVE');


INSERT INTO listvalue_field_value_detail (file_size,last_modified_on,last_modified_by,is_archive,is_active,value,field_key)
VALUES
(0,now(),-1,false,true,'T Multivitamin','drugInventoryMedicine'),
(0,now(),-1,false,true,'T Paracetamol','drugInventoryMedicine'),
(0,now(),-1,false,true,'T Iron Folic acid','drugInventoryMedicine'),
(0,now(),-1,false,true,'T vitamin B12','drugInventoryMedicine'),
(0,now(),-1,false,true,'T Folic acid','drugInventoryMedicine');



insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('drugInventoryMedicine')
) f(field)
where mfm.file_name in ('NCD_FHW_WEEKLY_CLINIC', 'NCD_FHW_WEEKLY_HOME');


insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_FHW_WEEKLY_HOME', 'NCD_FHW_WEEKLY_HOME', now(), -1, now(), -1);

insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW') and mfd.form_name = 'NCD_FHW_WEEKLY_HOME';

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name = 'NCD_FHW_WEEKLY_HOME' and mffr.mobile_constant = 'FHW_NCD_WEEKLY_VISIT';


DROP TABLE IF EXISTS public.ncd_member_home_visit_detail;
CREATE TABLE public.ncd_member_home_visit_detail
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
    clinic_date timestamp without time zone,
    systolic_bp integer,
    diastolic_bp integer,
    pulse_rate integer,
    hypertension_result character varying(200),
    mental_health_result character varying(200),
    diabetes_result character varying(200),
    talk integer,
    own_daily_work integer,
    social_work integer,
    understanding integer,
    blood_sugar integer,
    patient_taking_medicine boolean,
    any_adverse_effect boolean,
    adverse_effect text,
    required_reference boolean,
    given_consent boolean,
    referral_place character varying(200),
    other_referral_place character varying(200),
    referral_id integer,
    remarks text,
    done_by character varying (200),
    done_on timestamp without time zone
);