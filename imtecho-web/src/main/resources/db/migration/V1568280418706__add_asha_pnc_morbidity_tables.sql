DROP TABLE IF EXISTS rch_asha_pnc_mother_morbidity_master;

CREATE TABLE rch_asha_pnc_mother_morbidity_master
(
    id bigserial NOT NULL PRIMARY KEY,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    location_id bigint NOT NULL,
    pnc_id bigint,
    longitude text,
    latitude text,
    mobile_start_date timestamp without time zone,
    mobile_end_date timestamp without time zone,
    family_understand boolean,
    morbidity_found boolean,

    ready_for_referral boolean,
    able_to_call_108 boolean,
    call_log text,
    accompany_women boolean,
    referral_slip_given boolean,
    referral_place text,
    referral_vehicle text,
    mastitis_pcm_given text,
    mastitis_breast_feeding_understand boolean,
    mastitis_warm_water_understand boolean,
    feeding_problem_breast_feeding_understand boolean,
    feeding_problem_engorged_breast_understand boolean,
    feeding_problem_crakd_nipple_understand boolean,
    feeding_problem_retrctd_nipple_understand boolean,
    feeding_problem_family_understand boolean
);

DROP TABLE IF EXISTS rch_asha_pnc_mother_morbidity_details;

CREATE TABLE rch_asha_pnc_mother_morbidity_details
(
    morbidity_id bigint,
    code text,
    status character varying(1),
    symptoms text,
    PRIMARY KEY(morbidity_id, code),
    FOREIGN KEY (morbidity_id)
        REFERENCES rch_asha_pnc_mother_morbidity_master (id)
);

DROP TABLE IF EXISTS rch_asha_pnc_child_morbidity_master;

CREATE TABLE rch_asha_pnc_child_morbidity_master
(
    id bigserial NOT NULL PRIMARY KEY,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    location_id bigint NOT NULL,
    pnc_id bigint,
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
    sepsis_cotri_understand boolean,
    sepsis_cotri_given text,
    sepsis_warm_understand boolean,
    sepsis_breast_feeding_understand boolean,
    sepsis_syrup_pcm_given text,
    sepsis_gv_lotion text,
    vlbw_breast_feeding_understand boolean,
    vlbw_warm_understand boolean,
    vlbw_kmc_understand boolean,
    vlbw_call_understand boolean,
    bleeding_warm_understand boolean,
    bleeding_breast_feeding_understand boolean,
    jaundice_breast_feeding_understand boolean,
    jaundice_warm_understand boolean,
    diarrhoea_ors_understand boolean,
    diarrhoea_breast_feeding_understand boolean,
    diarrhoea_call_understand boolean,
    pneumonia_cotri_understand boolean,
    pneumonia_cotri_given text,
    pneumonia_call_understand boolean,
    local_infection_gv_lotion_understand boolean,
    local_infection_gv_lotion_given text,
    local_infection_call_understand boolean,
    hypothermia_risk_understand boolean,
    hypothermia_warm_understand boolean,
    hypothermia_kmc_understand boolean,
    hypothermia_kmc_help boolean,
    high_risk_lbw_breast_feeding_understand boolean,
    high_risk_lbw_warm_understand boolean,
    high_risk_lbw_kmc_understand boolean,
    high_risk_lbw_kmc_help boolean,
    high_risk_lbw_call_understand boolean,
    lbw_breast_feeding_understand boolean,
    lbw_kmc_understand boolean,
    lbw_warm_understand boolean,
    lbw_kmc_help boolean,
    lbw_call_understand boolean
);

DROP TABLE IF EXISTS rch_asha_pnc_child_morbidity_details;

CREATE TABLE rch_asha_pnc_child_morbidity_details
(
    morbidity_id bigint,
    code text,
    status character varying(1),
    symptoms text,
    PRIMARY KEY(morbidity_id, code),
    FOREIGN KEY (morbidity_id)
        REFERENCES rch_asha_pnc_child_morbidity_master (id)
);