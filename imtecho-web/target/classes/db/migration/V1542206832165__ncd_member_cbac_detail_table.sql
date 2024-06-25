DROP TABLE IF EXISTS public.ncd_member_cbac_detail;

CREATE TABLE public.ncd_member_cbac_detail
(
    id bigserial,
    member_id bigint,
    smoke_or_consume_gutka text,
    waist text,
    consume_alcohol_daily boolean,
    physical_activity_150_min text,
    bp_diabetes_heart_history boolean,
    shortness_of_breath boolean,
    fits_history boolean,
    two_weeks_coughing boolean,
    mouth_opening_difficulty boolean,
    blood_in_sputum boolean,
    two_weeks_ulcers_in_mouth boolean,
    two_weeks_fever boolean,
    change_in_tone_of_voice boolean,
    loss_of_weight boolean,
    patch_on_skin boolean,
    night_sweats boolean,
    taking_anti_tb_drugs boolean,
    difficulty_holding_objects boolean,
    sensation_loss_palm boolean,
    family_member_suffering_from_tb boolean,
    history_of_tb boolean,
    lump_in_breast boolean,
    bleeding_after_menopause boolean,
    nipple_blood_stained_discharge boolean,
    bleeding_after_intercourse boolean,
    change_in_size_of_breast boolean,
    foul_vaginal_discharge boolean,
    bleeding_between_periods boolean,
    occupational_exposure text,
    created_by bigint,
    created_on timestamp without time zone,
    modified_by bigint,
    modified_on timestamp without time zone,
    latitude character varying(100),
    longitude character varying(100),
    mobile_start_date timestamp without time zone NOT NULL,
    mobile_end_date timestamp without time zone NOT NULL
);

ALTER TABLE public.ncd_member_cbac_detail
  ADD PRIMARY KEY (id);

ALTER TABLE public.ncd_member_cbac_detail
   ALTER COLUMN member_id SET NOT NULL;
