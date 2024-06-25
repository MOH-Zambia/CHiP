alter table rch_anc_master
add column death_infra_id bigint;

alter table rch_member_death_deatil
add column health_infrastructure_id bigint;
