alter table if exists rch_vaccine_adverse_effect
add column if not exists service_date TIMESTAMP;

alter table if exists malaria_index_case_details
add column if not exists service_date TIMESTAMP;

alter table if exists malaria_non_index_case_details
add column if not exists service_date TIMESTAMP;

alter table if exists covid_screening_details
add column if not exists service_date TIMESTAMP;

alter table if exists tuberculosis_screening_details
add column if not exists service_date TIMESTAMP;

alter table if exists rch_preg_hiv_positive_master
add column if not exists service_date TIMESTAMP;

alter table if exists rch_hiv_screening_master
add column if not exists service_date TIMESTAMP;

alter table if exists rch_hiv_known_master
add column if not exists service_date TIMESTAMP;

alter table if exists emtct_details
add column if not exists service_date TIMESTAMP;




