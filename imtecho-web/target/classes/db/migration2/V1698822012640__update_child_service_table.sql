alter table rch_child_service_master
add column if not exists guardian_one_mobile_number text,
add column if not exists guardian_two_mobile_number text;