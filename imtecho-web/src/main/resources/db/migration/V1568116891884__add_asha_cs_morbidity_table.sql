DROP TABLE IF EXISTS rch_asha_cs_morbidity_master;

CREATE TABLE rch_asha_cs_morbidity_master
(
    id bigserial NOT NULL PRIMARY KEY,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    location_id bigint NOT NULL,
    cs_id bigint,
    longitude text,
    latitude text,
    mobile_start_date timestamp without time zone,
    mobile_end_date timestamp without time zone,
    family_understand boolean,
    morbidity_found boolean,

    ready_for_referral boolean,
    able_to_call_108 boolean,
    call_log text,
    accompany_child boolean,
    referral_slip_given boolean,
    referral_place text,
    referral_vehicle text,
    severe_pneumonia_oral_food boolean,
    severe_pneumonia_cotri_given text,
    chronic_cough_family_understand boolean,
    diarrhoea_severe_dehydration_oral_food boolean,
    diarrhoea_severe_dehydration_ors_given text,
    febrile_illness_cotri_given text,
    febrile_illness_slides_taken boolean,
    febrile_illness_chloroquine_given text,
    febrile_illness_pcm_given text,
    severe_malnutrition_vitamin_a_given text,
    severe_malnutrition_breast_feeding_understand boolean,
    severe_anemia_folic_given text,
    severe_persistent_diarrioea_oral_food boolean,
    severe_persistent_diarrioea_ors_given text,
    pneumonia_cotri_given text,
    pneumonia_cotrimoxazole_syrup boolean,
    pneumonia_family_understand boolean,
    diarrhoea_some_dehydration_ors_given text,
    diarrhoea_some_dehydration_ors_understand boolean,
    diarrhoea_some_dehydration_family_understand boolean,
    diarrhoea_some_dehydration_dehydration_understand boolean,
    dysentry_cotri_given text,
    dysentry_cotrimoxazole_syrup boolean,
    dysentry_return_immediately boolean,
    malaria_slides_taken boolean,
    malaria_chloroquine_given text,
    malaria_pcm_given text,
    malaria_fever_persist_family_understand boolean,
    anemia_folic_given text,
    cold_cough_family_understand boolean,
    diarrhoea_no_dehydration_ors_given text,
    diarrhoea_no_dehydration_ors_understand boolean,
    diarrhoea_no_dehydration_family_understand boolean,
    no_anemia_folic_given text
);

DROP TABLE IF EXISTS rch_asha_cs_morbidity_details;

CREATE TABLE rch_asha_cs_morbidity_details
(
    morbidity_id bigint,
    code text,
    status character varying(1),
    symptoms text,
    PRIMARY KEY(morbidity_id, code),
    FOREIGN KEY (morbidity_id)
        REFERENCES rch_asha_cs_morbidity_master (id)
);