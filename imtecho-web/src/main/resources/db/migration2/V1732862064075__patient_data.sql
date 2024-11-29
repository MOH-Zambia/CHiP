CREATE TABLE your_table_name (
    id BIGINT NOT NULL,
    referral_id VARCHAR(255),
    created_on TIMESTAMP WITHOUT TIME ZONE,
    nrc VARCHAR(255),
    created_by INTEGER,
    modified_on TIMESTAMP WITHOUT TIME ZONE,
    modified_by INTEGER,
    last_sync_date DATE,
    PRIMARY KEY (id)
);


ALTER TABLE imt_member
ADD COLUMN nupn TEXT;
