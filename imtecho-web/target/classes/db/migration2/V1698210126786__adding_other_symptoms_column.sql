alter table malaria_details
add column if not exists other_malaria_symptoms text;

alter table tuberculosis_screening_details
add column if not exists other_tb_symptoms text;

