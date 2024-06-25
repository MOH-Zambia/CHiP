DROP TABLE IF EXISTS rch_asha_anc_morbidity_master;

CREATE TABLE rch_asha_anc_morbidity_master
(
    id bigserial NOT NULL PRIMARY KEY,
    created_by bigint NOT NULL,
    created_on timestamp without time zone NOT NULL,
    modified_by bigint,
    modified_on timestamp without time zone,
    member_id bigint NOT NULL,
    family_id bigint NOT NULL,
    location_id bigint NOT NULL,
    anc_id bigint,
    longitude text,
    latitude text,
    mobile_start_date timestamp without time zone,
    mobile_end_date timestamp without time zone,
    family_understand boolean,
    morbidity_found boolean,
    family_understands_big_hospital boolean,
    ready_for_referral boolean,
    able_to_call_108 boolean,
    call_log text,
    accompany_women boolean,
    referral_slip_given boolean,
    referral_place text,
    referral_vehicle text,
    understand_hospital_delivery boolean,
    severe_anemia_ifa_understand boolean,
    sickle_cell_pcm_given boolean,
    bad_obstetric_doctor_visit boolean,
    bad_obstetric_hospital_visit boolean,
    bad_obstetric_hospital_delivery boolean,
    unintended_preg_continue_pregnancy boolean,
    unintended_preg_arrange_marriage boolean,
    unintended_preg_termination_understand boolean,
    unintended_preg_help boolean,
    mild_hypertension_hospital_delivery boolean,
    malaria_chloroquine_given boolean,
    malaria_pcm_given boolean,
    malaria_chloroquine_understand boolean,
    malaria_family_understand boolean,
    fever_pcm_given boolean,
    fever_phc_visit boolean,
    fever_family_understand boolean,
    urinary_tract_hospital_visit boolean,
    urinary_tract_family_understand boolean,
    vaginitis_hospital_visit boolean,
    vaginitis_family_understand boolean,
    vaginitis_bathe_daily boolean,
    night_blindness_vhnd_visit boolean,
    probable_anemia_ifa_understand boolean,
    probable_anemia_hospital_delivery boolean,
    emesis_pregnancy_family_understand boolean,
    respiratory_tract_drink_water boolean,
    moderate_anemia_ifa_given boolean,
    moderate_anemia_ifa_understand boolean,
    moderate_anemia_hospital_delivery boolean,
    breast_problem_demonstration boolean,
    breast_problem_syringe_given boolean
);

DROP TABLE IF EXISTS rch_asha_anc_morbidity_details;

CREATE TABLE rch_asha_anc_morbidity_details
(
    morbidity_id bigint,
    code text,
    status character varying(1),
    symptoms text,
    PRIMARY KEY(morbidity_id, code),
    FOREIGN KEY (morbidity_id)
        REFERENCES rch_asha_anc_morbidity_master (id) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);