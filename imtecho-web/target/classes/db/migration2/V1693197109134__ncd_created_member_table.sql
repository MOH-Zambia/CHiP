
Drop TABLE if exists public.imt_member_ncd_detail;
CREATE TABLE IF NOT EXISTS public.imt_member_ncd_detail
(
    id serial PRIMARY KEY NOT NULL,
    member_id integer NOT NULL,
	location_id integer,
    last_service_date timestamp without time zone,
    last_mo_visit timestamp without time zone,
    last_mobile_visit timestamp without time zone,
    last_mo_comment text,
    mo_confirmed_diabetes boolean,
    mo_confirmed_hypertension boolean,
    mo_confirmed_mental_health boolean,
    suffering_diabetes boolean,
    suffering_hypertension boolean,
    suffering_mental_health boolean,
    diabetes_details text,
    hypertension_details text,
    mental_health_details text,
    diabetes_treatment_status text,
    hypertension_treatment_status text,
    mentalHealth_treatment_status text,
    medicine_details text,
    disease_history text,
    notification_details text,
    diabetes_status text,
    hypertension_status text,
    mental_health_status text,
    diabetes_state text,
    hypertension_state text,
    mental_health_state text,
    last_remark text,
    created_by integer,
    created_on timestamp without time zone,
    modified_by integer,
    modified_on timestamp without time zone
);

update mobile_feature_master set mobile_display_name = 'NCD Confirmed Cases', modified_on = now()
where mobile_constant = 'FHW_NCD_WEEKLY_VISIT';

insert into mobile_feature_master (mobile_constant, feature_name, mobile_display_name, state, created_on, created_by, modified_on, modified_by)
values('FHW_NCD_CVC_DETAIL', 'FHW NCD CVC Detail', 'NCD CVC Detail', 'ACTIVE',  now(), -1, now(), -1);


insert into mobile_beans_master(bean, depends_on_last_sync)
values ('NcdMemberBean', true);

insert into mobile_beans_feature_rel(feature, bean)
values('FHW_NCD_CVC_DETAIL', 'FamilyBean'),
('FHW_NCD_CVC_DETAIL', 'NcdMemberBean');

update listvalue_field_value_detail set is_active = false, last_modified_on = now() where field_key=
(select field_key from public.listvalue_field_master where field = 'diseaseHistoryList')
and value='Diabetes';


insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_CVC_CLINIC', 'NCD_CVC_CLINIC', now(), -1, now(), -1);


insert into mobile_form_details(form_name,file_name,created_on,created_by,modified_on,modified_by)
values ('NCD_CVC_HOME', 'NCD_CVC_HOME', now(), -1, now(), -1);


insert into listvalue_field_form_relation(form_id, field)
select id, f.field
from
mobile_form_details mfm,
(
    values
        ('drugInventoryMedicine')
) f(field)
where mfm.file_name in ('NCD_CVC_HOME', 'NCD_CVC_CLINIC');


insert into mobile_form_role_rel(form_id, role_id)
select mfd.id, urm.id
from mobile_form_details mfd,
um_role_master urm
where urm.code in ('FHW','CC') and mfd.form_name in ('NCD_CVC_CLINIC','NCD_CVC_HOME');

insert into mobile_form_feature_rel (form_id,mobile_constant)
select mfd.id, mffr.mobile_constant
from mobile_form_details mfd,
mobile_feature_master mffr
where mfd.form_name in ('NCD_CVC_CLINIC','NCD_CVC_HOME') and mffr.mobile_constant = 'FHW_NCD_CVC_DETAIL';


DROP TABLE IF EXISTS public.ncd_member_cvc_home_visit_detail;
CREATE TABLE public.ncd_member_cvc_home_visit_detail
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
    patient_taking_medicine boolean,
    any_adverse_effect boolean,
    adverse_effect text,
    required_reference boolean,
    given_consent boolean,
    referral_place character varying(200),
    other_referral_place character varying(200),
    referral_id integer,
    remarks text,
    death_date date,
	death_place text,
    death_reason text,
	health_infra_id integer,
    reference_reason text,
	refer_status character varying(200),
    flag boolean,
    flag_reason character varying(200),
    other_reason text,
    followup_visit_type character varying(200),
    followup_date timestamp without time zone,
    done_by character varying (200),
    done_on timestamp without time zone
);

DROP TABLE IF EXISTS public.ncd_member_cvc_clinic_visit_detail;
CREATE TABLE public.ncd_member_cvc_clinic_visit_detail
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
    death_date date,
	death_place text,
    death_reason text,
	health_infra_id integer,
    done_by character varying (200),
    done_on timestamp without time zone
);

INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'NCD_CVC_CLINIC_VISIT','NCD CVC Clinic Visit','MO',30,'ACTIVE');


INSERT INTO public.notification_type_master(created_by, created_on,
modified_by, modified_on, code, name, type, role_id, state)
VALUES (-1,now(),-1,now(),'NCD_CVC_HOME_VISIT','NCD CVC Home Visit','MO',30,'ACTIVE');
