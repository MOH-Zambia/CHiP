alter table um_role_master
drop column if exists is_health_infra_mandatory,
add column is_health_infra_mandatory boolean;