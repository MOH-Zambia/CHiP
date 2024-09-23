drop table if exists gbv_visit_master;

-- V1__Create_example_table.sql
CREATE TABLE gbv_visit_master (
    id SERIAL PRIMARY KEY,
    further_treatment BOOLEAN,
    health_infra TEXT,
    service_date TIMESTAMP,
    case_date TIMESTAMP,
    member_status TEXT,
    severe_case BOOLEAN NOT NULL,
    client_response BOOLEAN NOT NULL,
    threatened_with_violence_past_12_months BOOLEAN NOT NULL,
    physically_hurt_past_12_months BOOLEAN NOT NULL,
    forced_sex_past_12_months BOOLEAN NOT NULL,
    forced_sex_for_essentials_past_12_months BOOLEAN NOT NULL,
    physically_forced_pregnancy_past_12_months BOOLEAN NOT NULL,
    pregnant_due_to_force BOOLEAN NOT NULL,
    forced_pregnancy_loss_past BOOLEAN NOT NULL,
    coerced_or_forced_marriage_past_12_months BOOLEAN NOT NULL,
    photo_doc_id TEXT,
    photo_unique_id TEXT,
    gbv_type TEXT,
    difficulty_type TEXT,
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

