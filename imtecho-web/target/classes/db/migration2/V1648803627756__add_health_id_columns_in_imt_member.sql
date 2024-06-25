alter table imt_member
drop column if exists health_id,
drop column if exists health_id_number,
add column health_id varchar(250),
add column health_id_number varchar(250);