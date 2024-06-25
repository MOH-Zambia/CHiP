
drop table if exists gbv_visit_master;

CREATE TABLE if not exists gbv_visit_master (
    id SERIAL PRIMARY KEY,
    member_status TEXT,
    client_response BOOLEAN,
    severe_case BOOLEAN,
    further_treatment BOOLEAN,
    health_infra TEXT,
    service_date TIMESTAMP,
    member_id INTEGER NOT NULL,
    family_id INTEGER NOT NULL,
    latitude TEXT,
    longitude TEXT,
    mobile_start_date TIMESTAMP NOT NULL,
    mobile_end_date TIMESTAMP NOT NULL,
    location_id INTEGER NOT NULL,
    location_hierarchy_id INTEGER NOT NULL,
    notification_id INTEGER,
    created_by INTEGER NOT NULL,
    created_on TIMESTAMP NOT NULL,
    modified_by INTEGER,
    modified_on TIMESTAMP
);


