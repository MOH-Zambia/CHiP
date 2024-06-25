alter table rch_child_service_master
add column if not exists child_symptoms text,
add column if not exists delays_observed text;

alter table malaria_index_case_details
add column if not exists latitude text,
add column if not exists longitude text;

alter table malaria_non_index_case_details
add column if not exists latitude text,
add column if not exists longitude text;



