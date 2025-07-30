DROP TABLE IF EXISTS patient_data;
CREATE TABLE if NOT exists patient_data (
    id SERIAL NOT NULL,
    referral_id VARCHAR(255),
    created_on TIMESTAMP WITHOUT TIME ZONE,
    nrc VARCHAR(255),
    created_by INTEGER,
    modified_on TIMESTAMP WITHOUT TIME ZONE,
    modified_by INTEGER,
    last_sync_date DATE,
    PRIMARY KEY (id)
);
