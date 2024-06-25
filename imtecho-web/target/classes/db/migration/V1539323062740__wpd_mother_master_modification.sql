alter table rch_wpd_mother_master
drop column if exists misoprostol_given,
drop column if exists free_drop_delivery,
drop column if exists delivery_person,
add column misoprostol_given boolean,
add column free_drop_delivery character varying(50),
add column delivery_person bigint