DROP TABLE IF EXISTS public.ncd_member_hypertension_detail;
CREATE TABLE public.ncd_member_hypertension_detail
(
    id bigserial PRIMARY KEY,
    member_id bigint,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    systolic_bp integer,
    diastolic_bp integer,
    pulse_rate integer,
    diagnosed_earlier boolean,
    currently_under_treatement boolean,
    refferal_done boolean,
    refferal_place text,
    remarks text
);

DROP TABLE IF EXISTS public.ncd_member_oral_detail;
CREATE TABLE public.ncd_member_oral_detail
(
    id bigserial PRIMARY KEY,
    member_id bigint,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    any_issues_in_mouth boolean,
    white_red_patch_oral_cavity boolean,
    difficulty_in_spicy_food boolean,
    voice_change boolean,
    difficulty_in_opening_mouth boolean,
    three_weeks_mouth_ulcer boolean,
    remarks text
);

DROP TABLE IF EXISTS public.ncd_member_breast_detail;
CREATE TABLE public.ncd_member_breast_detail
(
    id bigserial PRIMARY KEY,
    member_id bigint,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL,
    screening_date timestamp without time zone,
    any_breast_related_symptoms boolean,
    lump_in_breast boolean,
    size_change boolean,
    nipple_shape_and_position_change boolean,
    any_retraction_of_nipple boolean,
    discharge_from_nipple boolean,
    redness_of_skin_over_nipple boolean,
    erosions_of_nipple boolean,
    remarks text
);

