--Table: public.ncd_member_initial_assessment_detail
DROP TABLE IF EXISTS public.ncd_member_initial_assessment_detail;
CREATE TABLE IF NOT EXISTS public.ncd_member_initial_assessment_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default",
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    excess_thirst boolean,
    excess_urination boolean,
    excess_hunger boolean,
    recurrent_skin_gui boolean,
    delayed_healing_of_wounds boolean,
    change_in_dietary_habits boolean,
    sudden_visual_disturbances boolean,
    significant_edema boolean,
    breathlessness boolean,
    angina boolean,
    intermittent_claudication boolean,
    limpness boolean,
    diagnosed_earlier boolean,
    currently_under_treatement boolean,
    refferal_done boolean,
    height integer,
    waist_circumference integer,
    weight double precision,
    bmi double precision,
    done_by character varying(200) COLLATE pg_catalog."default",
    done_on timestamp without time zone,
    referral_id integer,
    location_id integer,
    family_id integer,
    health_infra_id integer,
    current_treatment_place character varying(20) COLLATE pg_catalog."default",
    is_continue_treatment_from_current_place boolean,
    is_suspected boolean,
    flag boolean
 );

-- Table: public.ncd_member_general_detail
DROP TABLE IF EXISTS public.ncd_member_general_detail;
CREATE TABLE IF NOT EXISTS public.ncd_member_general_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default",
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    excess_thirst boolean,
    communicable_disease boolean,
    rch boolean,
    minor_ailments boolean,
    ophthalmic boolean,
    oral_care boolean,
    geriatric_medicine boolean,
    ent boolean,
    emergency_trauma boolean,
    mental_health boolean,
    other boolean,
    mark_review boolean,
    diagnosed_earlier boolean,
    currently_under_treatement boolean,
    refferal_done boolean,
    symptoms text COLLATE pg_catalog."default",
    clinical_observation text COLLATE pg_catalog."default",
    diagnosis text COLLATE pg_catalog."default",
    comment text COLLATE pg_catalog."default",
    refferal_place text COLLATE pg_catalog."default",
    remarks text COLLATE pg_catalog."default",
    done_by character varying(200) COLLATE pg_catalog."default",
    done_on timestamp without time zone,
    referral_id integer,
    location_id integer,
    family_id integer,
    health_infra_id integer,
    current_treatment_place character varying(20) COLLATE pg_catalog."default",
    is_continue_treatment_from_current_place boolean,
    is_suspected boolean,
    flag boolean
);

-- Table: public.ncd_mbbsmo_review_detail
DROP TABLE IF EXISTS public.ncd_mbbsmo_review_detail;
CREATE TABLE IF NOT EXISTS public.ncd_mbbsmo_review_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default",
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    is_approved boolean,
    comment character varying(200) COLLATE pg_catalog."default",
    done_by character varying(200) COLLATE pg_catalog."default",
    done_on timestamp without time zone,
    location_id integer,
    family_id integer,
    health_infra_id integer,
    flag boolean
);

-- Table: public.ncd_drug_inventory_detail
DROP TABLE IF EXISTS public.ncd_drug_inventory_detail;
CREATE TABLE IF NOT EXISTS public.ncd_drug_inventory_detail
(
    id serial PRIMARY KEY,
    member_id integer,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone,
    latitude character varying(100) COLLATE pg_catalog."default",
    longitude character varying(100) COLLATE pg_catalog."default",
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    is_date timestamp without time zone,
    medicine_name character varying(100) COLLATE pg_catalog."default",
    isissued boolean,
    isreceived boolean,
    facility character varying(200) COLLATE pg_catalog."default",
    done_by character varying(200) COLLATE pg_catalog."default",
    done_on timestamp without time zone,
    location_id integer,
    family_id integer,
    health_infra_id integer,
    flag boolean,
    quantity_issued integer,
    quantity_received integer,
    parent_health_id integer,
    balance_in_hand integer
);

--ncd_member_oral_detail add columns
ALTER TABLE public.ncd_member_oral_detail
DROP COLUMN IF EXISTS submucous_fibrosis,
ADD COLUMN submucous_fibrosis VARCHAR;

ALTER TABLE public.ncd_member_oral_detail
DROP COLUMN IF EXISTS smokers_palate,
ADD COLUMN smokers_palate VARCHAR;

ALTER TABLE public.ncd_member_oral_detail
DROP COLUMN IF EXISTS lichen_planus,
ADD COLUMN lichen_planus VARCHAR;

ALTER TABLE public.ncd_member_oral_detail
DROP COLUMN IF EXISTS flag,
ADD COLUMN flag boolean;

ALTER TABLE public.ncd_member_oral_detail
ALTER COLUMN restricted_mouth_opening TYPE VARCHAR;

--ncd_member_mental_health_detail columns
ALTER TABLE public.ncd_member_mental_health_detail
DROP COLUMN IF EXISTS referral_id,
ADD COLUMN referral_id integer;

ALTER TABLE public.ncd_member_mental_health_detail
DROP COLUMN IF EXISTS talk,
ADD COLUMN talk integer;

ALTER TABLE public.ncd_member_mental_health_detail
DROP COLUMN IF EXISTS own_daily_work,
ADD COLUMN own_daily_work integer;

ALTER TABLE public.ncd_member_mental_health_detail
DROP COLUMN IF EXISTS social_work,
ADD COLUMN social_work integer;

ALTER TABLE public.ncd_member_mental_health_detail
DROP COLUMN IF EXISTS understanding,
ADD COLUMN understanding integer;

--ncd_member_cervical_detail columns
ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS external_genitalia_healthy,
ADD COLUMN external_genitalia_healthy boolean;

ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS flag,
ADD COLUMN flag boolean;

ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS onther_finding,
ADD COLUMN onther_finding boolean;

ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS does_suffering,
ADD COLUMN does_suffering boolean;

ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS bimanual_examination,
ADD COLUMN bimanual_examination VARCHAR;

ALTER TABLE public.ncd_member_cervical_detail
DROP COLUMN IF EXISTS onther_findings,
ADD COLUMN onther_findings VARCHAR;

--ncd_member_breast_detail columns
ALTER TABLE public.ncd_member_breast_detail
DROP COLUMN IF EXISTS flag,
ADD COLUMN flag boolean;

ALTER TABLE public.ncd_member_breast_detail
DROP COLUMN IF EXISTS skin_edema,
ADD COLUMN skin_edema boolean;

ALTER TABLE public.ncd_member_breast_detail
ALTER COLUMN visual_discharge_from_nipple TYPE VARCHAR;

ALTER TABLE public.ncd_member_breast_detail
DROP COLUMN IF EXISTS visual_skin_retraction,
ADD COLUMN visual_skin_retraction VARCHAR;

INSERT INTO listvalue_field_master(field_key, field, is_active, field_type, form)
VALUES('drugInventoryMedicine', 'drugInventoryMedicine', true, 'T', 'WEB');

INSERT INTO listvalue_field_value_detail (file_size,last_modified_on,last_modified_by,is_archive,is_active,value,field_key)
VALUES
(0,now(),-1,false,true,'Amlodipine 2.5 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Amlodipine 5 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'LAmlodipine 5mg+Hydrochlorothiazide 12.5mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Atenolol 25 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Atenolol 50 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Enalapril 2.5mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Enalapril 5mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Losartan 25mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Losartan 50mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Losartan 50mg+ Hydrochlorothiazide 12.5mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Furosemide 40','drugInventoryMedicine'),
(0,now(),-1,false,true,'Hydrochlorothiazide 12.5mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Telmiride AM','drugInventoryMedicine'),
(0,now(),-1,false,true,'Glimepiride 1mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Glimepiride 2mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Metformin 500','drugInventoryMedicine'),
(0,now(),-1,false,true,'Metformin 750 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Metformin 1000 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Glipizide 5 mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Salbutamol 2mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Salbutamol 4mg','drugInventoryMedicine'),
(0,now(),-1,false,true,'Escitalopram','drugInventoryMedicine'),
(0,now(),-1,false,true,'Clonazepam 0.25','drugInventoryMedicine'),
(0,now(),-1,false,true,'Olanzapine 5mg','drugInventoryMedicine');


-- To retrieve ncd_initialAssessment treatment history of patient

delete from query_master where code='ncd_initialAssessment_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, current_date, 'ncd_initialAssessment_treatment_history', 'memberId', '
select cast(ncd_member_initial_assessment_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_initial_assessment_detail
inner join ncd_member_referral on ncd_member_initial_assessment_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_initial_assessment_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_initial_assessment_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_initial_assessment_detail.member_id = #memberId#
group by ncd_member_initial_assessment_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_initial_assessment_detail.screening_date desc
', true, 'ACTIVE', 'To retrieve initialAssessment history of patient.');


-- To retrieve ncd_member_mental_health treatment history of patient

delete from query_master where code='ncd_mentalHealth_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, current_date, 'ncd_mentalHealth_treatment_history', 'memberId', '
select cast(ncd_member_mental_health_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_mental_health_detail
inner join ncd_member_referral on ncd_member_mental_health_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_mental_health_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_mental_health_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_mental_health_detail.member_id = #memberId#
group by ncd_member_mental_health_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_mental_health_detail.screening_date desc
', true, 'ACTIVE', 'To retrieve mental health disease treatment history of patient.');


-- To retrieve ncd_general treatment history of patient

delete from query_master where code='ncd_general_treatment_history';

insert into query_master(created_by, created_on, code, params, query, returns_result_set, state, description)
values(1, current_date, 'ncd_general_treatment_history', 'memberId', '
select cast(ncd_member_general_detail.screening_date as date) as "diagnosedOn",
concat(um_user.first_name, '' '', um_user.middle_name, '' '', um_user.last_name) as "diagnosedBy",
case when ncd_member_referral.status = ''MOBILE_REFERRED'' then ''Referred from mobile''
    when ncd_member_referral.status = ''SUSPECTED'' then ''Suspected''
	when ncd_member_referral.status = ''CONFIRMED'' then ''Confirmed''
	when ncd_member_referral.status = ''TREATMENT_STARTED'' then ''Treatment started''
	when ncd_member_referral.status = ''REFERRED'' then ''Referred to other facility''
	when ncd_member_referral.status = ''NO_ABNORMALITY'' then ''No abnormality'' end as status,
string_agg(medicine_master.name,'', '') as "medicines"
from ncd_member_general_detail
inner join ncd_member_referral on ncd_member_general_detail.referral_id = ncd_member_referral.id
inner join um_user on ncd_member_general_detail.created_by = um_user.id
left join ncd_member_disesase_medicine on ncd_member_general_detail.id = ncd_member_disesase_medicine.reference_id
left join medicine_master on ncd_member_disesase_medicine.medicine_id = medicine_master.id
where ncd_member_general_detail.member_id = #memberId#
group by ncd_member_general_detail.screening_date,
um_user.first_name,um_user.middle_name,um_user.last_name,ncd_member_referral.status
order by ncd_member_general_detail.screening_date desc
', true, 'ACTIVE', 'To retrieve general detail history of patient.');








