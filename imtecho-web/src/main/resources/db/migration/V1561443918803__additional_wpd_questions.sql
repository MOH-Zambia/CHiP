alter table rch_wpd_mother_master
drop column if exists free_medicines,
drop column if exists free_diet,
drop column if exists free_lab_test,
drop column if exists free_blood_transfusion,
drop column if exists free_drop_transport,
drop column if exists family_planning_method,
add column free_medicines boolean,
add column free_diet boolean,
add column free_lab_test boolean,
add column free_blood_transfusion boolean,
add column free_drop_transport boolean,
add column family_planning_method character varying;