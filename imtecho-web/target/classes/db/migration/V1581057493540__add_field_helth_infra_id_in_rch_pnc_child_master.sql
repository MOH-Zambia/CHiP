alter table rch_pnc_child_master
drop column if exists death_infra_id,
add column death_infra_id integer;