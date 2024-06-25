alter table ndhm_health_id_user_details
drop column if exists created_from,
drop column if exists auth_method_type,
add column created_from varchar(50),
add column auth_method_type varchar(50);
