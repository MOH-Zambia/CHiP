Drop table if exists store_referral_details;

CREATE TABLE store_referral_details (
    referral_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    referral_reason VARCHAR(100),
    service_area VARCHAR(100),
    member_id INT,
    nupn_id VARCHAR(100),
    referred_by INT,
    referred_from INT,
    referred_to INT,
    sync_status BOOLEAN,
    notes VARCHAR(100),
    visit_id INT,
    referred_on TIMESTAMP WITHOUT TIME ZONE,
    created_on TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    created_by INT NOT NULL,
    modified_on TIMESTAMP WITHOUT TIME ZONE,
    modified_by INT,
    referred_place VARCHAR(100)
);


