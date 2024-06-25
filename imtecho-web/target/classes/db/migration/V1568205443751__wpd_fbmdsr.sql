alter table rch_wpd_mother_master
drop column if exists fbmdsr,
add column fbmdsr boolean;