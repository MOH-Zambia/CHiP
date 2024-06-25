alter table anemia_member_detail
add column if not exists other_occupation text,
add column if not exists ambient_temperature float,
add column if not exists body_temperature float;