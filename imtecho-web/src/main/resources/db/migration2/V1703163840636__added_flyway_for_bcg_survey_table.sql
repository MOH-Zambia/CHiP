DROP TABLE IF EXISTS bcg_vaccination_survey_details;

DROP SEQUENCE IF EXISTS bcg_vaccination_survey_details_id_seq;

CREATE SEQUENCE IF NOT EXISTS bcg_vaccination_survey_details_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE bcg_vaccination_survey_details_id_seq
    OWNER TO postgres;


CREATE TABLE IF NOT EXISTS bcg_vaccination_survey_details (
    id bigserial PRIMARY KEY,
    tb_treatment BOOLEAN,
    tb_prevent_therapy BOOLEAN,
    tb_diagnosed BOOLEAN,
    cough_for_two_weeks BOOLEAN,
    fever_for_two_weeks BOOLEAN,
    significant_weight_loss BOOLEAN,
    blood_in_sputum BOOLEAN,
    consent_unavailable BOOLEAN,
    bed_ridden BOOLEAN,
    is_pregnant BOOLEAN,
    is_hiv BOOLEAN,
    is_cancer BOOLEAN,
    on_medication BOOLEAN,
    organ_transplant BOOLEAN,
    blood_transfusion BOOLEAN,
    bcg_allergy BOOLEAN,
    is_high_risk BOOLEAN,
    beneficiary_type VARCHAR(255),
    bcg_willing BOOLEAN,
    reason_for_not_willing VARCHAR(255),
    nikshay_id VARCHAR(255),
    hic VARCHAR(255),
    bcg_eligible BOOLEAN,
    height INT,
    weight FLOAT,
    bmi FLOAT,
    created_by INT NOT NULL,
    created_on TIMESTAMP NOT NULL,
    modified_by INT,
    modified_on TIMESTAMP
);

ALTER TABLE IF EXISTS bcg_vaccination_survey_details
    OWNER to postgres;


ALTER SEQUENCE bcg_vaccination_survey_details_id_seq OWNED BY bcg_vaccination_survey_details.id;
ALTER TABLE IF EXISTS ONLY bcg_vaccination_survey_details ALTER COLUMN id SET DEFAULT nextval('bcg_vaccination_survey_details_id_seq'::regclass);


alter table if exists bcg_vaccination_survey_details
alter column id type int;