CREATE TABLE IF NOT EXISTS referred_patient_data
(
    id SERIAL PRIMARY KEY,
    referral_id CHARACTER VARYING(255),
    created_on TIMESTAMP WITHOUT TIME ZONE,
    client_nupn CHARACTER VARYING(255),
    created_by INTEGER,
    modified_on TIMESTAMP WITHOUT TIME ZONE,
    modified_by INTEGER,
    last_sync_date DATE,
    status BOOLEAN
);

ALTER TABLE IF EXISTS store_referral_details 
        ADD COLUMN IF NOT EXISTS referral_sent BOOLEAN DEFAULT false;