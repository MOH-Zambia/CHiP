alter table idsp_member_screening_details
drop column if exists mobile_number,
drop column if exists other_country_name,
add column mobile_number text,
add column other_country_name text;