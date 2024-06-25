
alter table if exists rch_vaccine_adverse_effect
add column if not exists number_of_cluster int;


alter table if exists rch_vaccine_adverse_effect
add column if not exists cluster_id int;