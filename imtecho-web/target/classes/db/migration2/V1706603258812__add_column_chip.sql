alter table imt_member
add column if not exists why_stop_fp text;

alter table rch_anc_master
add column if not exists having_birth_plan boolean;

alter table malaria_details
add column if not exists member_status text;

alter table malaria_index_case_details
add column if not exists member_status text;

alter table malaria_non_index_case_details
add column if not exists member_status text;

alter table rch_preg_hiv_positive_master
add column if not exists member_status text;

alter table rch_hiv_screening_master
add column if not exists member_status text;

alter table rch_hiv_known_master
add column if not exists member_status text;

alter table tuberculosis_screening_details
add column if not exists member_status text;

alter table covid_screening_details
add column if not exists member_status text;
