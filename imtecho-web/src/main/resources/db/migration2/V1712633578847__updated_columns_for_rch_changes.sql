alter table rch_lmp_follow_up
drop column if exists rch_id;

alter table rch_wpd_mother_master
add column if not exists early_discharge_reason text;

alter table rch_anc_master
add column if not exists usg_done boolean;
