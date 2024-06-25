alter table imt_member
drop column if exists aadhaar_reference_key,
add column aadhaar_reference_key uuid;