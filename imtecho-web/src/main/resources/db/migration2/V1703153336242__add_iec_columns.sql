alter table malaria_details
add column if not exists is_iec_given boolean;

alter table tuberculosis_screening_details
add column if not exists is_iec_given boolean;

alter table covid_screening_details
add column if not exists is_iec_given boolean;

alter table imt_family
add column if not exists is_iec_given boolean;

alter table rch_anc_master
add column if not exists is_iec_given boolean;

alter table rch_child_service_master
add column if not exists is_iec_given boolean;

alter table rch_pnc_mother_master
add column if not exists is_iec_given boolean;

alter table imt_member
add column if not exists is_iec_given boolean;

alter table rch_wpd_mother_master
add column if not exists is_iec_given boolean;