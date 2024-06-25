alter table rch_anc_master
drop column if exists is_linked_to_abha,
add column is_linked_to_abha boolean;