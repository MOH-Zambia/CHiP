alter table um_user
drop column if exists rch_institution_master_id,
add column rch_institution_master_id bigint