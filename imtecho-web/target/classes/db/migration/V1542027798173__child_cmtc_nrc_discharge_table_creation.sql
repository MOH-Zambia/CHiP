DROP TABLE IF EXISTS public.child_cmtc_nrc_discharge_detail;

CREATE TABLE public.child_cmtc_nrc_discharge_detail
(
    id bigserial primary key,
    child_id bigint,
    referred_by bigint,
    higher_facility_referral text,
    referral_reason text,
    discharge_date timestamp without time zone,
    bilateral_pitting_oedema text,
    weight real,
    height integer,
    mid_upper_arm_circumference integer,
    illness text,
    sd_score text,
    discharge_status text,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone
);

alter table child_cmtc_nrc_screening_detail
drop column if exists discharge_id,
add column discharge_id bigint
