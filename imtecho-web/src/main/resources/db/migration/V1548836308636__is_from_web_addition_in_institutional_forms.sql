alter table rch_wpd_mother_master
drop column if exists is_from_web,
add column is_from_web boolean;

alter table rch_child_service_master
drop column if exists is_from_web,
add column is_from_web boolean;

alter table rch_anc_master
drop column if exists is_from_web,
add column is_from_web boolean;