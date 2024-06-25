DROP TABLE IF EXISTS public.child_cmtc_nrc_admission_detail;

CREATE TABLE public.child_cmtc_nrc_admission_detail
(
    id bigserial,
    child_id bigint,
    referred_by bigint,
    medical_officer_visit_flag boolean,
    specialist_pediatrician_visit_flag boolean,
    admission_date timestamp without time zone,
    apetite_test text,
    bilateral_pitting_oedema text,
    type_of_admission text,
    weight_at_admission real,
    height integer,
    mid_upper_arm_circumference integer,
    illness text,
    sd_score text
);
