alter table imt_member
drop column if exists husband_name,
add column husband_name text;