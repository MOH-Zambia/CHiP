drop sequence IF EXISTS public.imt_adolescent_member_id_seq;

CREATE SEQUENCE public.imt_adolescent_member_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

DROP TABLE IF EXISTS imt_adolescent_member;

CREATE TABLE IF NOT EXISTS imt_adolescent_member
(
    id integer NOT NULL DEFAULT nextval('imt_adolescent_member_id_seq'::regclass),
    member_id integer,
    unique_health_id text,
    service_location text,
    counselling_done text,
    school_actual_id text,
    height numeric,
    weight numeric,
    is_haemoglobin_measured boolean,
    clinical_diagnosis_hb text,
    health_infra_id text,
    haemoglobin numeric,
    ifa_tab_taken_last_month integer,
    ifa_tab_taken_now integer,
    is_period_started boolean,
    absorbent_material_used text,
    is_sanitary_pad_given boolean,
    no_of_sanitary_pads_given integer,
    lmp_date date,
    is_having_menstrual_problem boolean,
    issue_with_menstruation text,
    is_td_injection_given boolean,
    td_injection_date date,
    is_albandazole_given_in_last_six_months boolean,
    addiction text,
    major_illness text,
    is_having_juvenile_diabetes boolean,
    is_interested_in_studying boolean,
    is_behavior_diff_from_others boolean,
    adolescent_screening_date date,
    is_member_newly_added boolean,
    created_by integer NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by integer,
    modified_on timestamp without time zone,
    is_suffering_from_rti_sti boolean,
    is_having_skin_disease boolean,
    had_period_this_month boolean,
    is_upt_done boolean,
    contraceptive_methods_used text,
    mental_health_condition text,
    current_studying_standard text,
    other_diseases text,
    knows_about_family_planning boolean,
    location_id integer,
    CONSTRAINT imt_adolescent_member_pkey PRIMARY KEY (id)
)
